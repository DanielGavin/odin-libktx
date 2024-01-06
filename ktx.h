/* -*- tab-width: 4; -*- */
/* vi: set sw=2 ts=4 expandtab: */

#ifndef KTX_H_A55A6F00956F42F3A137C11929827FE1
#define KTX_H_A55A6F00956F42F3A137C11929827FE1



#include <limits.h>
#include <stdio.h>
#include <stdbool.h>
#include <sys/types.h>

#include <KHR/khr_df.h>



/* This will cause compilation to fail if size of uint32 != 4. */
typedef unsigned char ktx_uint32_t_SIZE_ASSERT[sizeof(ktx_uint32_t) == 4];

/*
 * This #if allows libktx to be compiled with strict c99. It avoids
 * compiler warnings or even errors when a gl.h is already included.
 * "Redefinition of (type) is a c11 feature". Obviously this doesn't help if
 * gl.h comes after. However nobody has complained about the unguarded typedefs
 * since they were introduced so this is unlikely to be a problem in practice.
 * Presumably everybody is using platform default compilers not c99 or else
 * they are using C++.
 */
#if !defined(GL_NO_ERROR)
  /*
   * To avoid having to including gl.h ...
   */
  typedef unsigned char GLboolean;
  typedef unsigned int GLenum;
  typedef int GLint;
  typedef int GLsizei;
  typedef unsigned int GLuint;
  typedef unsigned char GLubyte;
#endif

#ifdef __cplusplus
extern "C" {
#endif


#define KTX_FACESLICE_WHOLE_LEVEL UINT_MAX

#define KTX_TRUE  true
#define KTX_FALSE false

/**
 * @~English
 * @brief Error codes returned by library functions.
 */

/**
 * @deprecated
 * @~English
 * @brief For backward compatibility
 */
#define KTX_error_code ktx_error_code_e

#define KTX_IDENTIFIER_REF  { 0xAB, 0x4B, 0x54, 0x58, 0x20, 0x31, 0x31, 0xBB, 0x0D, 0x0A, 0x1A, 0x0A }
#define KTX_ENDIAN_REF      (0x04030201)
#define KTX_ENDIAN_REF_REV  (0x01020304)
#define KTX_HEADER_SIZE     (64)


/**
 * @class ktxHashList
 * @~English
 * @brief Opaque handle to a ktxHashList.
 */
typedef struct ktxKVListEntry* ktxHashList;

typedef struct ktxStream ktxStream;

#define KTX_APIENTRYP KTX_APIENTRY *
/**
 * @class ktxHashListEntry
 * @~English
 * @brief Opaque handle to an entry in a @ref ktxHashList.
 */
typedef struct ktxKVListEntry ktxHashListEntry;






/**
 * @typedef ktxTexture::classId
 * @~English
 * @brief Identify the class type.
 *
 * Since there are no public ktxTexture constructors, this can only have
 * values of ktxTexture1_c or ktxTexture2_c.
 */
/**
 * @typedef ktxTexture::vtbl
 * @~English
 * @brief Pointer to the class's vtble.
 */
/**
 * @typedef ktxTexture::vvtbl
 * @~English
 * @brief Pointer to the class's vtble for Vulkan functions.
 *
 * A separate vtble is used so this header does not need to include vulkan.h.
 */
/**
 * @typedef ktxTexture::_protected
 * @~English
 * @brief Opaque pointer to the class's protected variables.
 */
/**
 * @typedef ktxTexture::isArray
 * @~English
 *
 * KTX_TRUE if the texture is an array texture, i.e,
 * a GL_TEXTURE_*_ARRAY target is to be used.
 */
/**
 * @typedef ktxTexture::isCubemap
 * @~English
 *
 * KTX_TRUE if the texture is a cubemap or cubemap array.
 */
/**
 * @typedef ktxTexture::isCubemap
 * @~English
 *
 * KTX_TRUE if the texture's format is a block compressed format.
 */
/**
 * @typedef ktxTexture::generateMipmaps
 * @~English
 *
 * KTX_TRUE if mipmaps should be generated for the texture by
 * ktxTexture_GLUpload() or ktxTexture_VkUpload().
 */
/**n
 * @typedef ktxTexture::baseWidth
 * @~English
 * @brief Width of the texture's base level.
 */
/**
 * @typedef ktxTexture::baseHeight
 * @~English
 * @brief Height of the texture's base level.
 */
/**
 * @typedef ktxTexture::baseDepth
 * @~English
 * @brief Depth of the texture's base level.
 */
/**
 * @typedef ktxTexture::numDimensions
 * @~English
 * @brief Number of dimensions in the texture: 1, 2 or 3.
 */
/**
 * @typedef ktxTexture::numLevels
 * @~English
 * @brief Number of mip levels in the texture.
 *
 * Must be 1, if @c generateMipmaps is KTX_TRUE. Can be less than a
 * full pyramid but always starts at the base level.
 */
/**
 * @typedef ktxTexture::numLevels
 * @~English
 * @brief Number of array layers in the texture.
 */
/**
 * @typedef ktxTexture::numFaces
 * @~English
 * @brief Number of faces: 6 for cube maps, 1 otherwise.
 */
/**
 * @typedef ktxTexture::orientation
 * @~English
 * @brief Describes the logical orientation of the images in each dimension.
 *
 * ktxOrientationX for X, ktxOrientationY for Y and ktxOrientationZ for Z.
 */
/**
 * @typedef ktxTexture::kvDataHead
 * @~English
 * @brief Head of the hash list of metadata.
 */
/**
 * @typedef ktxTexture::kvDataLen
 * @~English
 * @brief Length of the metadata, if it has been extracted in its raw form,
 *       otherwise 0.
 */
/**
 * @typedef ktxTexture::kvData
 * @~English
 * @brief Pointer to the metadata, if it has been extracted in its raw form,
 *       otherwise NULL.
 */
/**
 * @typedef ktxTexture::dataSize
 * @~English
 * @brief Byte length of the texture's uncompressed image data.
 */
/**
 * @typedef ktxTexture::pData
 * @~English
 * @brief Pointer to the start of the image data.
 */

/**
 * @memberof ktxTexture
 * @~English
 * @brief Signature of function called by the <tt>ktxTexture_Iterate*</tt>
 *        functions to receive image data.
 *
 * The function parameters are used to pass values which change for each image.
 * Obtain values which are uniform across all images from the @c ktxTexture
 * object.
 *
 * @param [in] miplevel        MIP level from 0 to the max level which is
 *                             dependent on the texture size.
 * @param [in] face            usually 0; for cube maps, one of the 6 cube
 *                             faces in the order +X, -X, +Y, -Y, +Z, -Z,
 *                             0 to 5.
 * @param [in] width           width of the image.
 * @param [in] height          height of the image or, for 1D textures
 *                             textures, 1.
 * @param [in] depth           depth of the image or, for 1D & 2D
 *                             textures, 1.
 * @param [in] faceLodSize     number of bytes of data pointed at by
 *                             @p pixels.
 * @param [in] pixels          pointer to the image data.
 * @param [in,out] userdata    pointer for the application to pass data to and
 *                             from the callback function.
 */

typedef KTX_error_code
    (* PFNKTXITERCB)(int miplevel, int face,
                     int width, int height, int depth,
                     ktx_uint64_t faceLodSize,
                     void* pixels, void* userdata);

/* Don't use KTX_APIENTRYP to avoid a Doxygen bug. */
typedef void (KTX_APIENTRY* PFNKTEXDESTROY)(ktxTexture* This);
typedef KTX_error_code
    (KTX_APIENTRY* PFNKTEXGETIMAGEOFFSET)(ktxTexture* This, ktx_uint32_t level,
                                          ktx_uint32_t layer,
                                          ktx_uint32_t faceSlice,
                                          ktx_size_t* pOffset);
typedef ktx_size_t
    (KTX_APIENTRY* PFNKTEXGETDATASIZEUNCOMPRESSED)(ktxTexture* This);
typedef ktx_size_t
    (KTX_APIENTRY* PFNKTEXGETIMAGESIZE)(ktxTexture* This, ktx_uint32_t level);
typedef KTX_error_code
    (KTX_APIENTRY* PFNKTEXITERATELEVELS)(ktxTexture* This, PFNKTXITERCB iterCb,
                                         void* userdata);

typedef KTX_error_code
    (KTX_APIENTRY* PFNKTEXITERATELOADLEVELFACES)(ktxTexture* This,
                                                 PFNKTXITERCB iterCb,
                                                 void* userdata);
typedef KTX_error_code
    (KTX_APIENTRY* PFNKTEXLOADIMAGEDATA)(ktxTexture* This,
                                         ktx_uint8_t* pBuffer,
                                         ktx_size_t bufSize);
typedef ktx_bool_t
    (KTX_APIENTRY* PFNKTEXNEEDSTRANSCODING)(ktxTexture* This);

typedef KTX_error_code
    (KTX_APIENTRY* PFNKTEXSETIMAGEFROMMEMORY)(ktxTexture* This,
                                              ktx_uint32_t level,
                                              ktx_uint32_t layer,
                                              ktx_uint32_t faceSlice,
                                              const ktx_uint8_t* src,
                                              ktx_size_t srcSize);

typedef KTX_error_code
    (KTX_APIENTRY* PFNKTEXSETIMAGEFROMSTDIOSTREAM)(ktxTexture* This,
                                                   ktx_uint32_t level,
                                                   ktx_uint32_t layer,
                                                   ktx_uint32_t faceSlice,
                                                   FILE* src, ktx_size_t srcSize);
typedef KTX_error_code
    (KTX_APIENTRY* PFNKTEXWRITETOSTDIOSTREAM)(ktxTexture* This, FILE* dstsstr);
typedef KTX_error_code
    (KTX_APIENTRY* PFNKTEXWRITETONAMEDFILE)(ktxTexture* This,
                                            const char* const dstname);
typedef KTX_error_code
    (KTX_APIENTRY* PFNKTEXWRITETOMEMORY)(ktxTexture* This,
                                         ktx_uint8_t** bytes, ktx_size_t* size);
typedef KTX_error_code
    (KTX_APIENTRY* PFNKTEXWRITETOSTREAM)(ktxTexture* This,
                                         ktxStream* dststr);

/**
 * @memberof ktxTexture
 * @~English
 * @brief Table of virtual ktxTexture methods.
 */
 struct ktxTexture_vtbl {
    PFNKTEXDESTROY Destroy;
    PFNKTEXGETIMAGEOFFSET GetImageOffset;
    PFNKTEXGETDATASIZEUNCOMPRESSED GetDataSizeUncompressed;
    PFNKTEXGETIMAGESIZE GetImageSize;
    PFNKTEXITERATELEVELS IterateLevels;
    PFNKTEXITERATELOADLEVELFACES IterateLoadLevelFaces;
    PFNKTEXNEEDSTRANSCODING NeedsTranscoding;
    PFNKTEXLOADIMAGEDATA LoadImageData;
    PFNKTEXSETIMAGEFROMMEMORY SetImageFromMemory;
    PFNKTEXSETIMAGEFROMSTDIOSTREAM SetImageFromStdioStream;
    PFNKTEXWRITETOSTDIOSTREAM WriteToStdioStream;
    PFNKTEXWRITETONAMEDFILE WriteToNamedFile;
    PFNKTEXWRITETOMEMORY WriteToMemory;
    PFNKTEXWRITETOSTREAM WriteToStream;
};

/****************************************************************
 * Macros to give some backward compatibility to the previous API
 ****************************************************************/

/**
 * @~English
 * @brief Helper for calling the Destroy virtual method of a ktxTexture.
 * @copydoc ktxTexture2.ktxTexture2_Destroy
 */
#define ktxTexture_Destroy(This) (This)->vtbl->Destroy(This)

/**
 * @~English
 * @brief Helper for calling the GetImageOffset virtual method of a
 *        ktxTexture.
 * @copydoc ktxTexture2.ktxTexture2_GetImageOffset
 */
#define ktxTexture_GetImageOffset(This, level, layer, faceSlice, pOffset) \
            (This)->vtbl->GetImageOffset(This, level, layer, faceSlice, pOffset)

/**
 * @~English
 * @brief Helper for calling the GetDataSizeUncompressed virtual method of a ktxTexture.
 *
 * For a ktxTexture1 this will always return the value of This->dataSize.
 *
 * @copydetails ktxTexture2.ktxTexture2_GetDataSizeUncompressed
 */
#define ktxTexture_GetDataSizeUncompressed(This) \
                                (This)->vtbl->GetDataSizeUncompressed(This)

/**
 * @~English
 * @brief Helper for calling the GetImageSize virtual method of a ktxTexture.
 * @copydoc ktxTexture2.ktxTexture2_GetImageSize
 */
#define ktxTexture_GetImageSize(This, level) \
            (This)->vtbl->GetImageSize(This, level)

/**
 * @~English
 * @brief Helper for calling the IterateLevels virtual method of a ktxTexture.
 * @copydoc ktxTexture2.ktxTexture2_IterateLevels
 */
#define ktxTexture_IterateLevels(This, iterCb, userdata) \
                            (This)->vtbl->IterateLevels(This, iterCb, userdata)

/**
 * @~English
 * @brief Helper for calling the IterateLoadLevelFaces virtual method of a
 * ktxTexture.
 * @copydoc ktxTexture2.ktxTexture2_IterateLoadLevelFaces
 */
 #define ktxTexture_IterateLoadLevelFaces(This, iterCb, userdata) \
                    (This)->vtbl->IterateLoadLevelFaces(This, iterCb, userdata)

/**
 * @~English
 * @brief Helper for calling the LoadImageData virtual method of a ktxTexture.
 * @copydoc ktxTexture2.ktxTexture2_LoadImageData
 */
#define ktxTexture_LoadImageData(This, pBuffer, bufSize) \
                    (This)->vtbl->LoadImageData(This, pBuffer, bufSize)

/**
 * @~English
 * @brief Helper for calling the NeedsTranscoding virtual method of a ktxTexture.
 * @copydoc ktxTexture2.ktxTexture2_NeedsTranscoding
 */
#define ktxTexture_NeedsTranscoding(This) (This)->vtbl->NeedsTranscoding(This)

/**
 * @~English
 * @brief Helper for calling the SetImageFromMemory virtual method of a
 *        ktxTexture.
 * @copydoc ktxTexture2.ktxTexture2_SetImageFromMemory
 */
#define ktxTexture_SetImageFromMemory(This, level, layer, faceSlice, \
                                      src, srcSize)                  \
    (This)->vtbl->SetImageFromMemory(This, level, layer, faceSlice, src, srcSize)

/**
 * @~English
 * @brief Helper for calling the SetImageFromStdioStream virtual method of a
 *        ktxTexture.
 * @copydoc ktxTexture2.ktxTexture2_SetImageFromStdioStream
 */
#define ktxTexture_SetImageFromStdioStream(This, level, layer, faceSlice, \
                                           src, srcSize)                  \
    (This)->vtbl->SetImageFromStdioStream(This, level, layer, faceSlice,  \
                                        src, srcSize)

/**
 * @~English
 * @brief Helper for calling the WriteToStdioStream virtual method of a
 *        ktxTexture.
 * @copydoc ktxTexture2.ktxTexture2_WriteToStdioStream
 */
#define ktxTexture_WriteToStdioStream(This, dstsstr) \
                                (This)->vtbl->WriteToStdioStream(This, dstsstr)

/**
 * @~English
 * @brief Helper for calling the WriteToNamedfile virtual method of a
 *        ktxTexture.
 * @copydoc ktxTexture2.ktxTexture2_WriteToNamedFile
 */
#define ktxTexture_WriteToNamedFile(This, dstname) \
                                (This)->vtbl->WriteToNamedFile(This, dstname)

/**
 * @~English
 * @brief Helper for calling the WriteToMemory virtual method of a ktxTexture.
 * @copydoc ktxTexture2.ktxTexture2_WriteToMemory
 */
#define ktxTexture_WriteToMemory(This, ppDstBytes, pSize) \
                  (This)->vtbl->WriteToMemory(This, ppDstBytes, pSize)

/**
 * @~English
 * @brief Helper for calling the WriteToStream virtual method of a ktxTexture.
 * @copydoc ktxTexture2.ktxTexture2_WriteToStream
 */
#define ktxTexture_WriteToStream(This, dststr) \
                  (This)->vtbl->WriteToStream(This, dststr)



/*===========================================================*
* KTX format version 2                                      *
*===========================================================*/



/**
 * @brief Helper for casting ktxTexture1 and ktxTexture2 to ktxTexture.
 *
 * Use with caution.
 */
#define ktxTexture(t) ((ktxTexture*)t)




/*===========================================================*
* ktxStream
*===========================================================*/

/*
 * This is unsigned to allow ktxmemstreams to use the
 * full amount of memory available. Platforms will
 * limit the size of ktxfilestreams to, e.g, MAX_LONG
 * on 32-bit and ktxfilestreams raises errors if
 * offset values exceed the limits. This choice may
 * need to be revisited if we ever start needing -ve
 * offsets.
 *
 * Should the 2GB file size handling limit on 32-bit
 * platforms become a problem, ktxfilestream will have
 * to be changed to explicitly handle large files by
 * using the 64-bit stream functions.
 */
#if defined(_MSC_VER) && defined(_WIN64)
  typedef unsigned __int64 ktx_off_t;
#else
  typedef   off_t ktx_off_t;
#endif
typedef struct ktxMem ktxMem;
typedef struct ktxStream ktxStream;








extern KTX_API const ktx_uint32_t KTX_ETC1S_DEFAULT_COMPRESSION_LEVEL;






#ifdef __cplusplus
}
#endif




#endif /* KTX_H_A55A6F00956F42F3A137C11929827FE1 */
