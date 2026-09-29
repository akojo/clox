#include "CppUTest/TestHarness.h"

extern "C"
{
#include "chunk.h"
}

TEST_GROUP(chunk)
{
    Chunk *chunk;

    void setup()
    {
        chunk = (Chunk *)malloc(sizeof(Chunk));
        initChunk(chunk);
    }

    void teardown()
    {
        freeChunk(chunk);
        free(chunk);
    }
};

TEST(chunk, Init)
{
    LONGS_EQUAL(0, chunk->capacity);
    LONGS_EQUAL(0, chunk->count);
}

TEST(chunk, WriteChunk)
{
    writeChunk(chunk, OP_RETURN);

    LONGS_EQUAL(1, chunk->count);
}
