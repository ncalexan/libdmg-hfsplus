#include <string.h>
#include <zlib.h> // For crc32_combine.
#include "abstractfile.h"
#include "common.h"
#include <dmg/attribution.h>
#include <dmg/dmg.h>
/* #include <dmg/dmgfile.h> */

typedef struct AttributionPreservingSentinelData {
	char* sentinel;

	// TODO: possibly support multiple sentinel occurrences?  For now, only one.
	ChecksumToken beforeRaw_UncompressedChkToken;
	ChecksumToken raw_UncompressedChkToken;
	ChecksumToken afterRaw_UncompressedChkToken;
	int64_t beforeRaw_UncompressedLength;
	// -1 if sentinel (raw block) not yet seen.
	int64_t raw_UncompressedLength;
	int64_t afterRaw_UncompressedLength;

	ChecksumToken beforeRaw_CompressedChkToken;
	ChecksumToken raw_CompressedChkToken;
	ChecksumToken afterRaw_CompressedChkToken;
	int64_t beforeRaw_CompressedLength;
	// -1 if sentinel (raw block) not yet seen.
	int64_t raw_CompressedLength;
	int64_t afterRaw_CompressedLength;
} AttributionPreservingSentinelData;

char const *
FindStrInBuf(char const * buf, size_t bufLen, char const * str)
{
  size_t index = 0;
  while (index < bufLen) {
    char const * result = strstr(buf + index, str);
    if (result) {
      return result;
    }
    while ((buf[index] != '\0') && (index < bufLen)) {
      index++;
    }
    index++;
  }
  return NULL;
}

int sentinelShouldKeepRaw(AbstractAttribution* attribution, const void* data, size_t len) {
	AttributionPreservingSentinelData* attributionData = (AttributionPreservingSentinelData*)attribution->data;
	/* return FALSE; */
	return NULL != FindStrInBuf((char const*)data, len, (const char*)attributionData->sentinel);
}

void sentinelBeforeMainBlkx(AbstractAttribution* attribution, AbstractFile* abstractOut, ChecksumToken* dataForkToken) {

	AttributionPreservingSentinelData* attributionData = (AttributionPreservingSentinelData*)attribution->data;
	memcpy(&attributionData->beforeRaw_CompressedChkToken, dataForkToken, sizeof(ChecksumToken));
	attributionData->beforeRaw_CompressedLength = abstractOut->tell(abstractOut);
    // printf("sentinelBeforeMainBlkx: data->beforeRaw_CompressedChkToken CRC32: %x\n", attributionData->beforeRaw_CompressedChkToken.crc);
}

void sentinelObserveBuffers(AbstractAttribution* attribution, int didKeepRaw, const void* uncompressedData, size_t uncompressedLen, const void* compressedData, size_t compressedLen) {
	AttributionPreservingSentinelData* attributionData = (AttributionPreservingSentinelData*)attribution->data;

	if (didKeepRaw) {
		ASSERT(attributionData->raw_UncompressedLength == -1, "Only one raw block supported!");
		ASSERT(attributionData->raw_CompressedLength == -1, "Only one raw block supported!");

		// Just in case.
		memset(&attributionData->raw_UncompressedChkToken, 0, sizeof(ChecksumToken));
		memset(&attributionData->raw_CompressedChkToken, 0, sizeof(ChecksumToken));

		CRCProxy(&attributionData->raw_UncompressedChkToken, uncompressedData, uncompressedLen);
		attributionData->raw_UncompressedLength = uncompressedLen;
		printf("Adding to raw_UncompressedChkToken, now CRC32: %x, length: %llx\n", attributionData->raw_UncompressedChkToken.crc, attributionData->raw_UncompressedLength);

		// Of course, the compressed data *should* be the uncompressed data.
		CRCProxy(&attributionData->raw_CompressedChkToken, compressedData, compressedLen);
		attributionData->raw_CompressedLength = compressedLen;
		printf("Adding to raw_CompressedChkToken, now CRC32: %x, length: %llx\n", attributionData->raw_CompressedChkToken.crc, attributionData->raw_CompressedLength);

		ASSERT(attributionData->afterRaw_UncompressedLength == -1, "Only one raw block supported!");
		ASSERT(attributionData->afterRaw_CompressedLength == -1, "Only one raw block supported!");

		attributionData->afterRaw_UncompressedLength = 0;
		attributionData->afterRaw_CompressedLength = 0;
		// Just in case.
		memset(&attributionData->afterRaw_UncompressedChkToken, 0, sizeof(ChecksumToken));
		memset(&attributionData->afterRaw_CompressedChkToken, 0, sizeof(ChecksumToken));
	} else {
		if (attributionData->afterRaw_UncompressedLength < 0) {
			CRCProxy(&attributionData->beforeRaw_UncompressedChkToken, uncompressedData, uncompressedLen);
			attributionData->beforeRaw_UncompressedLength += uncompressedLen;
			printf("Adding to beforeRaw_UncompressedChkToken, now CRC32: %x, length: %llx\n", attributionData->beforeRaw_UncompressedChkToken.crc, attributionData->beforeRaw_UncompressedLength);
		} else {
			CRCProxy(&attributionData->afterRaw_UncompressedChkToken, uncompressedData, uncompressedLen);
			attributionData->afterRaw_UncompressedLength += uncompressedLen;
			printf("Adding to afterRaw_UncompressedChkToken, now CRC32: %x, length: %llx\n", attributionData->afterRaw_UncompressedChkToken.crc, attributionData->afterRaw_UncompressedLength);
		}

		if (attributionData->afterRaw_CompressedLength < 0) {
			CRCProxy(&attributionData->beforeRaw_CompressedChkToken, compressedData, compressedLen);
			attributionData->beforeRaw_CompressedLength += compressedLen;
			printf("Adding to beforeRaw_CompressedChkToken, now CRC32: %x, length: %llx\n", attributionData->beforeRaw_CompressedChkToken.crc, attributionData->beforeRaw_CompressedLength);
		} else {
			CRCProxy(&attributionData->afterRaw_CompressedChkToken, compressedData, compressedLen);
			attributionData->afterRaw_CompressedLength += compressedLen;
			printf("Adding to afterRaw_CompressedChkToken, now CRC32: %x, length: %llx\n", attributionData->afterRaw_CompressedChkToken.crc, attributionData->afterRaw_CompressedLength);
		}
	}
}

void sentinelAfterMainBlkx(AbstractAttribution* attribution, AbstractFile* abstractOut, ChecksumToken* dataForkToken, AttributionResource* attributionResource) {
  AttributionPreservingSentinelData* data = attribution->data;

  // Sentinels no longer make sense.
  if (data->raw_UncompressedLength < 0) {
    data->raw_UncompressedLength = 0;
  }
  if (data->afterRaw_UncompressedLength < 0) {
    data->afterRaw_UncompressedLength = 0;
  }
  if (data->raw_CompressedLength < 0) {
    data->raw_CompressedLength = 0;
  }
  if (data->afterRaw_CompressedLength < 0) {
    data->afterRaw_CompressedLength = 0;
  }

  printf("\n");
  printf("data->beforeRaw_UncompressedChkToken CRC32: 0x%x, length: 0x%llx\n", data->beforeRaw_UncompressedChkToken.crc, data->beforeRaw_UncompressedLength);
  printf("data->raw_UncompressedChkToken CRC32: 0x%x, length: 0x%llx\n", data->raw_UncompressedChkToken.crc, data->raw_UncompressedLength);
  printf("data->afterRaw_UncompressedChkToken CRC32: 0x%x, length: 0x%llx\n", data->afterRaw_UncompressedChkToken.crc, data->afterRaw_UncompressedLength);
  // printf("uncompressedChkToken CRC32: 0x%x, length: 0x%llx\n", ((ChecksumToken*)uncompressedChkToken)->crc, -1); // curSector * SECTOR_SIZE);

  printf("uncompressed combined CRC32: 0x%lx\n",
         crc32_combine(crc32_combine(data->beforeRaw_UncompressedChkToken.crc, data->raw_UncompressedChkToken.crc, data->raw_UncompressedLength),
                       data->afterRaw_UncompressedChkToken.crc, data->afterRaw_UncompressedLength));

  printf("\n");
  printf("data->beforeRaw_CompressedChkToken CRC32: 0x%x, length: 0x%llx\n", data->beforeRaw_CompressedChkToken.crc, data->beforeRaw_CompressedLength);
  printf("data->raw_CompressedChkToken CRC32: 0x%x, length: 0x%llx\n", data->raw_CompressedChkToken.crc, data->raw_CompressedLength);
  printf("data->afterRaw_CompressedChkToken CRC32: 0x%x, length: 0x%llx\n", data->afterRaw_CompressedChkToken.crc, data->afterRaw_CompressedLength);
  // XXX this length is wrong!
  // printf("compressedChkToken CRC32: 0x%x, length: 0x%llx\n", ((ChecksumToken*)compressedChkToken)->crc, -1); // curSector * SECTOR_SIZE);

  // printf("compressed combined CRC32: 0x%lx\n", crc32_combine(data->beforeRaw_CompressedChkToken.crc, data->afterRaw_CompressedChkToken.crc, data->afterRaw_CompressedLength));
  printf("compressed combined CRC32: 0x%lx\n\n",
         crc32_combine(crc32_combine(data->beforeRaw_CompressedChkToken.crc, data->raw_CompressedChkToken.crc, data->raw_CompressedLength),
                       data->afterRaw_CompressedChkToken.crc, data->afterRaw_CompressedLength));

  // Update attribution metadata.
  attributionResource->signature = ATTR_SIGNATURE;
  attributionResource->version = 1;

  attributionResource->beforeCompressedLength = data->beforeRaw_CompressedLength;
  attributionResource->beforeCompressedChecksum = data->beforeRaw_CompressedChkToken.crc;
  attributionResource->beforeUncompressedLength = data->beforeRaw_UncompressedLength;
  attributionResource->beforeUncompressedChecksum = data->beforeRaw_UncompressedChkToken.crc;

  attributionResource->rawPos = data->beforeRaw_CompressedLength;
  attributionResource->rawLength = data->raw_CompressedLength;
  attributionResource->rawChecksum = data->raw_CompressedChkToken.crc;

  attributionResource->afterCompressedLength = data->afterRaw_CompressedLength;
  attributionResource->afterCompressedChecksum = data->afterRaw_CompressedChkToken.crc;
  attributionResource->afterUncompressedLength = data->afterRaw_UncompressedLength;
  attributionResource->afterUncompressedChecksum = data->afterRaw_UncompressedChkToken.crc;

  printf("sentinelAfterMainBlkx: %d, 0x%llx, 0x%llx\n", attributionResource->version, attributionResource->rawPos, attributionResource->rawLength);
}

AbstractAttribution* createAbstractAttributionPreservingSentinel(const char* sentinel) {
	AbstractAttribution* attribution;
	attribution = (AbstractAttribution*) malloc(sizeof(AbstractAttribution));

	AttributionPreservingSentinelData* data = malloc(sizeof(AttributionPreservingSentinelData));
	memset(data, 0, sizeof(AttributionPreservingSentinelData));
	data->sentinel = malloc(strlen(sentinel));
	strcpy(data->sentinel, sentinel);
	data->raw_UncompressedLength = -1;
	data->afterRaw_UncompressedLength = -1;
	data->raw_CompressedLength = -1;
	data->afterRaw_CompressedLength = -1;

	attribution->data = data;
	attribution->beforeMainBlkx = sentinelBeforeMainBlkx;
	attribution->shouldKeepRaw = sentinelShouldKeepRaw;
	attribution->observeBuffers = sentinelObserveBuffers;
	attribution->afterMainBlkx = sentinelAfterMainBlkx;
	return attribution;
}

uint32_t calculateMasterChecksum(ResourceKey* resources);

int updateAttribution(AbstractFile* abstractIn, AbstractFile* abstractOut, const char* anchor, const char* data, size_t dataLen)
{
  // In an `attributable` DMG file:
  // - read `attribution` resource
  // - update bytes in BZ_RAW block in place
  // - update <blkx> checksum: there's a UDIF checksum (34 bytes?) in
  //   each <blkx> dict, which is part of a Base64 encoded struct.  We
  //   can Base64 decode to bytes, swizzle the 4 bytes of the
  //   checksum, and then Base64 encode back to the same number of
  //   bytes.
  // - update data fork checksum (compressed)
  // - update master checksum (uncompressed)

  off_t fileLength;
  UDIFResourceFile resourceFile;

  ResourceData* curData;

  fileLength = abstractIn->getLength(abstractIn);
  abstractIn->seek(abstractIn, fileLength - sizeof(UDIFResourceFile));
  readUDIFResourceFile(abstractIn, &resourceFile);

  char* resourceXML;

  resourceXML = malloc(resourceFile.fUDIFXMLLength + 1);
  ASSERT( abstractIn->seek(abstractIn, (off_t)(resourceFile.fUDIFXMLOffset)) == 0, "fseeko" );
  ASSERT( abstractIn->read(abstractIn, resourceXML, (size_t)resourceFile.fUDIFXMLLength) == (size_t)resourceFile.fUDIFXMLLength, "fread" );
  resourceXML[resourceFile.fUDIFXMLLength] = 0;

  ResourceKey* resources;
  resources = readResources(resourceXML, resourceFile.fUDIFXMLLength);
  ResourceKey* resource = getResourceByKey(resources, "attribution");
  AttributionResource* attributionResource = (AttributionResource*)(resource->data->data);

  ASSERT(attributionResource->signature == ATTR_SIGNATURE, "bad attr signature!");
  ASSERT(attributionResource->version == 1, "only version 1 recognized");

  printf("attribution: at 0x%llx, 0x%llx bytes\n",
         attributionResource->rawPos,
         attributionResource->rawLength);

  // Step 1.  Replace bytes at anchor.
  ASSERT(abstractIn->seek(abstractIn, 0) == 0, "seek in");
  size_t inLength = abstractIn->getLength(abstractIn);
  while (1) {
    unsigned char buffer[8192];
    size_t readLength = abstractIn->read(abstractIn, buffer, 8192);
    ASSERT(readLength == abstractOut->write(abstractOut, buffer, readLength), "write copy");
    if (readLength < 8192) {
      break;
    }
  }

  ASSERT(abstractIn->seek(abstractIn, attributionResource->rawPos) == 0, "seek in");
  char* rawBuffer = malloc(attributionResource->rawLength);
  ASSERT(rawBuffer, "malloc rawBuffer");
  ASSERT(abstractIn->read(abstractIn, rawBuffer, attributionResource->rawLength) == attributionResource->rawLength, "read raw in");

  printf("Looking for anchor: '%s'\n", anchor);

  const char* rawAnchor = FindStrInBuf((const char*)rawBuffer, attributionResource->rawLength, anchor);
  ASSERT(rawAnchor, "anchor position");

  int64_t anchorOffset = rawAnchor - rawBuffer;
  printf("anchorOffset: 0x%llx\n", anchorOffset);

  ASSERT(rawAnchor + dataLen <= rawBuffer + attributionResource->rawLength, "data too long!");
  memcpy((void *)rawAnchor, data, dataLen);

  // Write the new block.
  ASSERT(abstractOut->seek(abstractOut, attributionResource->rawPos) == 0, "seek out");
  ASSERT(abstractOut->write(abstractOut, rawBuffer, attributionResource->rawLength) == attributionResource->rawLength, "write data");

  // New block checksum.
  ChecksumToken newRawToken;
  memset(&newRawToken, 0, sizeof(ChecksumToken));
  CRCProxy(&newRawToken, (unsigned char*)rawBuffer, attributionResource->rawLength);

  free(rawBuffer);

  // Step 2: update "attribution" resource.
  attributionResource->rawChecksum = newRawToken.crc;

  // Step 3.  Update blkx checksum.

  // TODO: check ranges of all the partitions and runs to be sure we're identifying the correct file system.
  int partNum = -1;
  ResourceData* blkxData = NULL;
  if(partNum < 0) {
    blkxData = getResourceByKey(resources, "blkx")->data;
    while(blkxData != NULL) {
      if(strstr(blkxData->name, "Apple_HFS") != NULL) {
        break;
      }
      blkxData = blkxData->next;
    }
  } else {
    blkxData = getDataByID(getResourceByKey(resources, "blkx"), partNum);
  }

  ASSERT(blkxData, "blkxData");

  BLKXTable* blkx = (BLKXTable*)(blkxData->data);
  blkx->checksum.data[0] =
    crc32_combine(crc32_combine(attributionResource->beforeUncompressedChecksum, newRawToken.crc, attributionResource->rawLength),
                  attributionResource->afterUncompressedChecksum, attributionResource->afterUncompressedLength);

  ASSERT( abstractOut->seek(abstractOut, (off_t)(resourceFile.fUDIFXMLOffset)) == 0, "fseeko" );
  writeResources(abstractOut, resources);

  // Step 4.  Update koly block checksums.

  resourceFile.fUDIFDataForkChecksum.type = CHECKSUM_UDIF_CRC32;
  resourceFile.fUDIFDataForkChecksum.bitness = checksumBitness(CHECKSUM_UDIF_CRC32);
  resourceFile.fUDIFDataForkChecksum.data[0] =
    crc32_combine(crc32_combine(attributionResource->beforeCompressedChecksum, newRawToken.crc, attributionResource->rawLength),
                  attributionResource->afterCompressedChecksum, attributionResource->afterCompressedLength);

  resourceFile.fUDIFMasterChecksum.type = CHECKSUM_UDIF_CRC32;
  resourceFile.fUDIFMasterChecksum.bitness = checksumBitness(CHECKSUM_UDIF_CRC32);
  resourceFile.fUDIFMasterChecksum.data[0] = calculateMasterChecksum(resources);
  printf("Master checksum: %x\n", resourceFile.fUDIFMasterChecksum.data[0]); fflush(stdout);

  printf("Writing out UDIF resource file...\n"); fflush(stdout);

  writeUDIFResourceFile(abstractOut, &resourceFile);

  printf("Cleaning up...\n"); fflush(stdout);

  releaseResources(resources);

  abstractIn->close(abstractIn);

  printf("Done\n"); fflush(stdout);

  abstractOut->close(abstractOut);

  return TRUE;
}