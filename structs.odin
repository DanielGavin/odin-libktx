package libktx

import "core:c"


HashList :: distinct c.size_t
HashListEntry :: distinct c.size_t


TEXTURECLASSDEFN :: struct {
	class_id:        class_id,
	vtbl:            rawptr,
	vvtbl:           rawptr,
	_protected:      rawptr,
	isArray:         b32,
	isCubemap:       b32,
	isCompressed:    b32,
	generateMipmaps: b32,
	baseWidth:       u32,
	baseHeight:      u32,
	baseDepth:       u32,
	numDimensions:   u32,
	numLevels:       u32,
	numLayers:       u32,
	numFaces:        u32,
	orientation:     Orientation,
	kvDataHead:      HashList,
	kvDataLen:       u32,
	kvData:          [^]u8,
	dataSize:        c.size_t,
	pData:           [^]u8,
}


//Struct describing the logical orientation of an image.
Orientation :: struct {
	x: OrientationX,
	y: OrientationY,
	z: OrientationZ,
}

/**
 * @class ktxTexture
 * @brief Base class representing a texture.
 *
 * ktxTextures should be created only by one of the provided
 * functions and these fields should be considered read-only.
 */
Texture :: struct {
	using _: TEXTURECLASSDEFN,
}


/**
 * @class ktxTexture1
 * @brief Class representing a KTX version 1 format texture.
 *
 * ktxTextures should be created only by one of the ktxTexture_Create*
 * functions and these fields should be considered read-only.
 */
Texture1 :: struct {
	using _:              TEXTURECLASSDEFN,
	glFormat:             u32, // Format of the texture data, e.g., GL_RGB. 
	glInternalformat:     u32, // Internal format of the texture data, e.g., GL_RGB8. 
	glBaseInternalformat: u32, // Base format of the texture data, e.g., GL_RGB. 
	glType:               u32, // Type of the texture data, e.g, GL_UNSIGNED_BYTE. struct ktxTexture1_private* _private; /*!< Private data. 
}

/**
 * @class ktxTexture2
 * @brief Class representing a KTX version 2 format texture.
 *
 * ktxTextures should be created only by one of the ktxTexture_Create*
 * functions and these fields should be considered read-only.
 */
Texture2 :: struct {
	using _:                TEXTURECLASSDEFN,
	vkFormat:               u32,
	pDfd:                   [^]u32,
	supercompressionScheme: SupercmpScheme,
	isVideo:                b32,
	duration:               u32,
	timescale:              u32,
	loopcount:              u32,
	_private:               rawptr,
}

/**
 * @memberof ktxTexture
 * @brief Structure for passing texture information to ktxTexture1\_Create() and
 *        ktxTexture2\_Create().
 *
 * @sa @ref ktxTexture1::ktxTexture1\_Create() "ktxTexture1_Create()"
 * @sa @ref ktxTexture2::ktxTexture2\_Create() "ktxTexture2_Create()"
 */
TextureCreateInfo :: struct {
	glInternalformat: u32, // Internal format for the texture, e.g., GL_RGB8. Ignored when creating a ktxTexture2.
	vkFormat:         u32, // VkFormat for texture. Ignored when creating a ktxTexture1.
	pDfd:             [^]u32, // Pointer to DFD. Used only when creating a ktxTexture2 and only if vkFormat is VK_FORMAT_UNDEFINED.
	baseWidth:        u32, // Width of the base level of the texture. 
	baseHeight:       u32, // Height of the base level of the texture. 
	baseDepth:        u32, // Depth of the base level of the texture.
	numDimensions:    u32, // Number of dimensions in the texture, 1, 2 or 3.
	numLevels:        u32, // Number of mip levels in the texture. Should be 1 if @c generateMipmaps is KTX_TRUE; 
	numLayers:        u32, // Number of array layers in the texture.
	numFaces:         u32, // Number of faces: 6 for cube maps, 1 otherwise. 
	isArray:          b32, // Set to KTX_TRUE if the texture is to be an array texture. Means OpenGL will use a GL_TEXTURE_*_ARRAY target.
	generateMipmaps:  b32, // Set to KTX_TRUE if mipmaps should be generated for the texture when loading into a 3D API. 
}

/**
 * @brief Interface of ktxStream.
 *
 */
Stream :: struct {
	read:            Stream_read, /*!< pointer to function for reading bytes. */
	skip:            Stream_skip, /*!< pointer to function for skipping bytes. */
	write:           Stream_write, /*!< pointer to function for writing bytes. */
	getpos:          Stream_getpos, /*!< pointer to function for getting current position in stream. */
	setpos:          Stream_setpos, /*!< pointer to function for setting current position in stream. */
	getsize:         Stream_getsize, /*!< pointer to function for querying size. */
	destruct:        Stream_destruct, /*!< destruct the stream. */
	type:            streamType,
	data:            [3]c.size_t,
	readpos:         c.size_t, /**< used by FileStream for stdin. */
	closeOnDestruct: b32, /**< Close FILE* or dispose of memory on destruct. */
}


/**
 * @memberof ktxTexture
 * @brief Structure for passing extended parameters to
 *        ktxTexture_CompressAstc.
 *
 * Passing a struct initialized to 0 (e.g. " = {0};") will use blockDimension
 * 4x4, mode LDR and qualityLevel FASTEST. Setting qualityLevel to
 * KTX_PACK_ASTC_QUALITY_LEVEL_MEDIUM is recommended.
 */
AstcParams :: struct {
	structSize:     u32,
	/*!< Size of this struct. Used so library can tell which version
             of struct is being passed.
         */
	verbose:        b32,
	/*!< If true, prints Astc encoder operation details to
             @c stdout. Not recommended for GUI apps.
         */
	threadCount:    u32,
	/*!< Number of threads used for compression. Default is 1.
         */

	/* astcenc params */
	blockDimension: u32,
	/*!< Combinations of block dimensions that astcenc supports
          i.e. 6x6, 8x8, 6x5 etc
         */
	mode:           u32,
	/*!< Can be {ldr/hdr} from astcenc
         */
	qualityLevel:   u32,
	/*!< astcenc supports -fastest, -fast, -medium, -thorough, -exhaustive
         */
	normalMap:      b32,
	/*!< Tunes codec parameters for better quality on normal maps
          In this mode normals are compressed to X,Y components
          Discarding Z component, reader will need to generate Z
          component in shaders.
         */
	perceptual:     b32,
	/*!< The codec should optimize for perceptual error, instead of direct
           RMS error. This aims to improves perceived image quality, but
           typically lowers the measured PSNR score. Perceptual methods are
           currently only available for normal maps and RGB color data.
         */
	inputSwizzle:   [4]u8,
	/*!< A swizzle to provide as input to astcenc. It must match the regular
             expression /^[rgba01]{4}$/.
          */
}


/**
 * @memberof ktxTexture2
 * @brief Structure for passing extended parameters to
 *        ktxTexture2_CompressBasisEx().
 *
 * If you only want default values, use ktxTexture2_CompressBasis(). Here, at a minimum you
 * must initialize the structure as follows:
 * @code
 *  ktxBasisParams params = {0};
 *  params.structSize = sizeof(params);
 *  params.compressionLevel = KTX_ETC1S_DEFAULT_COMPRESSION_LEVEL;
 * @endcode
 *
 * @e compressionLevel has to be explicitly set because 0 is a valid @e compressionLevel
 * but is not the default used by the BasisU encoder when no value is set. Only the other
 * settings that are to be non-default must be non-zero.
 */
BasisParams :: struct {
	structSize:                       u32,
	/*!< Size of this struct. Used so library can tell which version
             of struct is being passed.
         */
	uastc:                            b32,
	/*!<  True to use UASTC base, false to use ETC1S base. */
	verbose:                          b32,
	/*!< If true, prints Basis Universal encoder operation details to
             @c stdout. Not recommended for GUI apps.
         */
	noSSE:                            b32,
	/*!< True to forbid use of the SSE instruction set. Ignored if CPU
             does not support SSE. */
	threadCount:                      u32,
	/*!< Number of threads used for compression. Default is 1. */

	/* ETC1S params */
	compressionLevel:                 u32,
	/*!< Encoding speed vs. quality tradeoff. Range is [0,5]. Higher values
             are slower, but give higher quality. There is no default. Callers
             must explicitly set this value. Callers can use
             KTX_ETC1S_DEFAULT_COMPRESSION_LEVEL as a default value.
             Currently this is 2.
        */
	qualityLevel:                     u32,
	/*!< Compression quality. Range is [1,255].  Lower gives better
             compression/lower quality/faster. Higher gives less compression
             /higher quality/slower.  This automatically determines values for
             @c maxEndpoints, @c maxSelectors,
             @c endpointRDOThreshold and @c selectorRDOThreshold
             for the target quality level. Setting these parameters overrides
             the values determined by @c qualityLevel which defaults to
             128 if neither it nor both of @c maxEndpoints and
             @c maxSelectors have been set.
             @note @e Both of @c maxEndpoints and @c maxSelectors
             must be set for them to have any effect.
             @note qualityLevel will only determine values for
             @c endpointRDOThreshold and @c selectorRDOThreshold
             when its value exceeds 128, otherwise their defaults will be used.
        */
	maxEndpoints:                     u32,
	/*!< Manually set the max number of color endpoint clusters.
             Range is [1,16128]. Default is 0, unset. If this is set, maxSelectors
             must also be set, otherwise the value will be ignored.
         */
	endpointRDOThreshold:             f32,
	/*!< Set endpoint RDO quality threshold. The default is 1.25. Lower is
             higher quality but less quality per output bit (try [1.0,3.0].
             This will override the value chosen by @c qualityLevel.
         */
	maxSelectors:                     u32,
	/*!< Manually set the max number of color selector clusters. Range
             is [1,16128]. Default is 0, unset. If this is set, maxEndpoints
             must also be set, otherwise the value will be ignored.
         */
	selectorRDOThreshold:             f32,
	/*!< Set selector RDO quality threshold. The default is 1.5. Lower is
             higher quality but less quality per output bit (try [1.0,3.0]).
             This will override the value chosen by @c qualityLevel.
         */
	inputSwizzle:                     [4]u8,
	/*!< A swizzle to apply before encoding. It must match the regular
             expression /^[rgba01]{4}$/. If both this and preSwizzle
             are specified ktxTexture_CompressBasisEx will raise
             KTX_INVALID_OPERATION.
         */
	normalMap:                        b32,
	/*!< Tunes codec parameters for better quality on normal maps (no
             selector RDO, no endpoint RDO) and sets the texture's DFD appropriately.
             Only valid for linear textures.
         */
	separateRGToRGB_A:                b32,
	/*!< @deprecated. This was and is a no-op. 2-component inputs have always been
             automatically separated using an "rrrg" inputSwizzle. @sa inputSwizzle and normalMode.
         */
	preSwizzle:                       b32,
	/*!< If the texture has @c KTXswizzle metadata, apply it before
             compressing. Swizzling, like @c rabb may yield drastically
             different error metrics if done after supercompression.
         */
	noEndpointRDO:                    b32,
	/*!< Disable endpoint rate distortion optimizations. Slightly faster,
             less noisy output, but lower quality per output bit. Default is
             KTX_FALSE.
         */
	noSelectorRDO:                    b32,
	/*!< Disable selector rate distortion optimizations. Slightly faster,
             less noisy output, but lower quality per output bit. Default is
             KTX_FALSE.
         */

	/* UASTC params */
	uastcFlags:                       pack_uastc_flags,
	/*!<  A set of ::ktx_pack_uastc_flag_bits_e controlling UASTC
             encoding. The most important value is the level given in the
             least-significant 4 bits which selects a speed vs quality tradeoff
             as shown in the following table:

                Level/Speed | Quality
                :-----: | :-------:
                KTX_PACK_UASTC_LEVEL_FASTEST | 43.45dB
                KTX_PACK_UASTC_LEVEL_FASTER | 46.49dB
                KTX_PACK_UASTC_LEVEL_DEFAULT | 47.47dB
                KTX_PACK_UASTC_LEVEL_SLOWER  | 48.01dB
                KTX_PACK_UASTC_LEVEL_VERYSLOW | 48.24dB
         */
	uastcRDO:                         b32,
	/*!< Enable Rate Distortion Optimization (RDO) post-processing.
         */
	uastcRDOQualityScalar:            f32,
	/*!< UASTC RDO quality scalar (lambda). Lower values yield higher
             quality/larger LZ compressed files, higher values yield lower
             quality/smaller LZ compressed files. A good range to try is [.2,4].
             Full range is [.001,50.0]. Default is 1.0.
         */
	uastcRDODictSize:                 u32,
	/*!< UASTC RDO dictionary size in bytes. Default is 4096. Lower
             values=faster, but give less compression. Range is [64,65536].
         */
	uastcRDOMaxSmoothBlockErrorScale: f32,
	/*!< UASTC RDO max smooth block error scale. Range is [1,300].
             Default is 10.0, 1.0 is disabled. Larger values suppress more
             artifacts (and allocate more bits) on smooth blocks.
         */
	uastcRDOMaxSmoothBlockStdDev:     f32,
	/*!< UASTC RDO max smooth block standard deviation. Range is
             [.01,65536.0]. Default is 18.0. Larger values expand the range of
             blocks considered smooth.
         */
	uastcRDODontFavorSimplerModes:    b32,
	/*!< Do not favor simpler UASTC modes in RDO mode.
         */
	uastcRDONoMultithreading:         b32,
	/*!< Disable RDO multithreading (slightly higher compression,
             deterministic).
         */
}
