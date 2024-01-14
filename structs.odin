package libktx

import "core:c"

import vk "vendor:vulkan"

HashList :: distinct c.size_t
HashListEntry :: distinct c.size_t

Texture_vtbl :: struct {
	Destroy:                 PFNKTEXDESTROY,
	GetImageOffset:          PFNKTEXGETIMAGEOFFSET,
	GetDataSizeUncompressed: PFNKTEXGETDATASIZEUNCOMPRESSED,
	GetImageSize:            PFNKTEXGETIMAGESIZE,
	IterateLevels:           PFNKTEXITERATELEVELS,
	IterateLoadLevelFaces:   PFNKTEXITERATELOADLEVELFACES,
	NeedsTranscoding:        PFNKTEXNEEDSTRANSCODING,
	LoadImageData:           PFNKTEXLOADIMAGEDATA,
	SetImageFromMemory:      PFNKTEXSETIMAGEFROMMEMORY,
	SetImageFromStdioStream: rawptr,
	WriteToStdioStream:      rawptr,
	WriteToNamedFile:        PFNKTEXWRITETONAMEDFILE,
	WriteToMemory:           PFNKTEXWRITETOMEMORY,
	WriteToStream:           PFNKTEXWRITETOSTREAM,
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
	class_id:        class_id,
	vtbl:            ^Texture_vtbl,
	vvtbl:           rawptr,
	_protected:      rawptr,
	isArray:         c.bool,
	isCubemap:       c.bool,
	isCompressed:    c.bool,
	generateMipmaps: c.bool,
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


/**
 * @class ktxTexture1
 * @brief Class representing a KTX version 1 format texture.
 *
 * ktxTextures should be created only by one of the ktxTexture_Create*
 * functions and these fields should be considered read-only.
 */
Texture1 :: struct {
	using _:              Texture,
	glFormat:             u32, // Format of the texture data, e.g., GL_RGB. 
	glInternalformat:     u32, // Internal format of the texture data, e.g., GL_RGc.bool. 
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
	using _:                Texture,
	vkFormat:               vk.Format,
	pDfd:                   [^]u32,
	supercompressionScheme: SupercmpScheme,
	isVideo:                c.bool,
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
	glInternalformat: u32, // Internal format for the texture, e.g., GL_RGc.bool. Ignored when creating a ktxTexture2.
	vkFormat:         vk.Format, // VkFormat for texture. Ignored when creating a ktxTexture1.
	pDfd:             [^]u32, // Pointer to DFD. Used only when creating a ktxTexture2 and only if vkFormat is VK_FORMAT_UNDEFINED.
	baseWidth:        u32, // Width of the base level of the texture. 
	baseHeight:       u32, // Height of the base level of the texture. 
	baseDepth:        u32, // Depth of the base level of the texture.
	numDimensions:    u32, // Number of dimensions in the texture, 1, 2 or 3.
	numLevels:        u32, // Number of mip levels in the texture. Should be 1 if @c generateMipmaps is KTX_TRUE; 
	numLayers:        u32, // Number of array layers in the texture.
	numFaces:         u32, // Number of faces: 6 for cube maps, 1 otherwise. 
	isArray:          c.bool, // Set to KTX_TRUE if the texture is to be an array texture. Means OpenGL will use a GL_TEXTURE_*_ARRAY target.
	generateMipmaps:  c.bool, // Set to KTX_TRUE if mipmaps should be generated for the texture when loading into a 3D API. 
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
	closeOnDestruct: c.bool, /**< Close FILE* or dispose of memory on destruct. */
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
	verbose:        c.bool,
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
	normalMap:      c.bool,
	/*!< Tunes codec parameters for better quality on normal maps
          In this mode normals are compressed to X,Y components
          Discarding Z component, reader will need to generate Z
          component in shaders.
         */
	perceptual:     c.bool,
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
	uastc:                            c.bool,
	/*!<  True to use UASTC base, false to use ETC1S base. */
	verbose:                          c.bool,
	/*!< If true, prints Basis Universal encoder operation details to
             @c stdout. Not recommended for GUI apps.
         */
	noSSE:                            c.bool,
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
	normalMap:                        c.bool,
	/*!< Tunes codec parameters for better quality on normal maps (no
             selector RDO, no endpoint RDO) and sets the texture's DFD appropriately.
             Only valid for linear textures.
         */
	separateRGToRGB_A:                c.bool,
	/*!< @deprecated. This was and is a no-op. 2-component inputs have always been
             automatically separated using an "rrrg" inputSwizzle. @sa inputSwizzle and normalMode.
         */
	preSwizzle:                       c.bool,
	/*!< If the texture has @c KTXswizzle metadata, apply it before
             compressing. Swizzling, like @c rabb may yield drastically
             different error metrics if done after supercompression.
         */
	noEndpointRDO:                    c.bool,
	/*!< Disable endpoint rate distortion optimizations. Slightly faster,
             less noisy output, but lower quality per output bit. Default is
             KTX_FALSE.
         */
	noSelectorRDO:                    c.bool,
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
	uastcRDO:                         c.bool,
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
	uastcRDODontFavorSimplerModes:    c.bool,
	/*!< Do not favor simpler UASTC modes in RDO mode.
         */
	uastcRDONoMultithreading:         c.bool,
	/*!< Disable RDO multithreading (slightly higher compression,
             deterministic).
         */
}

khr_df_model :: enum {
	/* No interpretation of color channels defined */
	MODEL_UNSPECIFIED = 0,
	/* Color primaries (red, green, blue) + alpha, depth and stencil */
	MODEL_RGBSDA      = 1,
	/* Color differences (Y', Cb, Cr) + alpha, depth and stencil */
	MODEL_YUVSDA      = 2,
	/* Color differences (Y', I, Q) + alpha, depth and stencil */
	MODEL_YIQSDA      = 3,
	/* Perceptual color (CIE L*a*b*) + alpha, depth and stencil */
	MODEL_LABSDA      = 4,
	/* Subtractive colors (cyan, magenta, yellow, black) + alpha */
	MODEL_CMYKA       = 5,
	/* Non-color coordinate data (X, Y, Z, W) */
	MODEL_XYZW        = 6,
	/* Hue, saturation, value, hue angle on color circle, plus alpha */
	MODEL_HSVA_ANG    = 7,
	/* Hue, saturation, lightness, hue angle on color circle, plus alpha */
	MODEL_HSLA_ANG    = 8,
	/* Hue, saturation, value, hue on color hexagon, plus alpha */
	MODEL_HSVA_HEX    = 9,
	/* Hue, saturation, lightness, hue on color hexagon, plus alpha */
	MODEL_HSLA_HEX    = 10,
	/* Lightweight approximate color difference (luma, orange, green) */
	MODEL_YCGCOA      = 11,
	/* ITU BT.2020 constant luminance YcCbcCrc */
	MODEL_YCCBCCRC    = 12,
	/* ITU BT.2100 constant intensity ICtCp */
	MODEL_ICTCP       = 13,
	/* CIE 1931 XYZ color coordinates (X, Y, Z) */
	MODEL_CIEXYZ      = 14,
	/* CIE 1931 xyY color coordinates (X, Y, Y) */
	MODEL_CIEXYY      = 15,

	/* Compressed formats start at 128. */
	/* These compressed formats should generally have a single sample,
       sited at the 0,0 position of the texel block. Where multiple
       channels are used to distinguish formats, these should be cosited. */
	/* Direct3D (and S3) compressed formats */
	/* Note that premultiplied status is recorded separately */
	/* DXT1 "channels" are RGB (0), Alpha (1) */
	/* DXT1/BC1 with one channel is opaque */
	/* DXT1/BC1 with a cosited alpha sample is transparent */
	MODEL_DXT1A       = 128,
	MODEL_BC1A        = 128,
	/* DXT2/DXT3/BC2, with explicit 4-bit alpha */
	MODEL_DXT2        = 129,
	MODEL_DXT3        = 129,
	MODEL_BC2         = 129,
	/* DXT4/DXT5/BC3, with interpolated alpha */
	MODEL_DXT4        = 130,
	MODEL_DXT5        = 130,
	MODEL_BC3         = 130,
	/* BC4 - single channel interpolated 8-bit data */
	/* (The UNORM/SNORM variation is recorded in the channel data) */
	MODEL_BC4         = 131,
	/* BC5 - two channel interpolated 8-bit data */
	/* (The UNORM/SNORM variation is recorded in the channel data) */
	MODEL_BC5         = 132,
	/* BC6H - DX11 format for 16-bit float channels */
	MODEL_BC6H        = 133,
	/* BC7 - DX11 format */
	MODEL_BC7         = 134,
	/* Gap left for future desktop expansion */

	/* Mobile compressed formats follow */
	/* A format of ETC1 indicates that the format shall be decodable
       by an ETC1-compliant decoder and not rely on ETC2 features */
	MODEL_ETC1        = 160,
	/* A format of ETC2 is permitted to use ETC2 encodings on top of
       the baseline ETC1 specification */
	/* The ETC2 format has channels "red", "green", "RGB" and "alpha",
       which should be cosited samples */
	/* Punch-through alpha can be distinguished from full alpha by
       the plane size in bytes required for the texel block */
	MODEL_ETC2        = 161,
	/* Adaptive Scalable Texture Compression */
	/* ASTC HDR vs LDR is determined by the float flag in the channel */
	/* ASTC block size can be distinguished by texel block size */
	MODEL_ASTC        = 162,
	/* ETC1S is a simplified subset of ETC1 */
	MODEL_ETC1S       = 163,
	/* PowerVR Texture Compression */
	MODEL_PVRTC       = 164,
	MODEL_PVRTC2      = 165,
	MODEL_UASTC       = 166,
}


/**
 * @struct VulkanFunctions
 * @brief Struct for applications to pass Vulkan function pointers to the
 *        ktxTexture_VkUpload functions via a ktxVulkanDeviceInfo struct.
 *
 * @c vkGetInstanceProcAddr and @c vkGetDeviceProcAddr should be set, others
 * are optional.
 */
VulkanFunctions :: struct {
	vkGetInstanceProcAddr:                    vk.ProcGetInstanceProcAddr,
	vkGetDeviceProcAddr:                      vk.ProcGetDeviceProcAddr,
	vkAllocateCommandBuffers:                 vk.ProcAllocateCommandBuffers,
	vkAllocateMemory:                         vk.ProcAllocateMemory,
	vkBeginCommandBuffer:                     vk.ProcBeginCommandBuffer,
	vkBindBufferMemory:                       vk.ProcBindBufferMemory,
	vkBindImageMemory:                        vk.ProcBindImageMemory,
	vkCmdBlitImage:                           vk.ProcCmdBlitImage,
	vkCmdCopyBufferToImage:                   vk.ProcCmdCopyBufferToImage,
	vkCmdPipelineBarrier:                     vk.ProcCmdPipelineBarrier,
	vkCreateImage:                            vk.ProcCreateImage,
	vkDestroyImage:                           vk.ProcDestroyImage,
	vkCreateBuffer:                           vk.ProcCreateBuffer,
	vkDestroyBuffer:                          vk.ProcDestroyBuffer,
	vkCreateFence:                            vk.ProcCreateFence,
	vkDestroyFence:                           vk.ProcDestroyFence,
	vkEndCommandBuffer:                       vk.ProcEndCommandBuffer,
	vkFreeCommandBuffers:                     vk.ProcFreeCommandBuffers,
	vkFreeMemory:                             vk.ProcFreeMemory,
	vkGetBufferMemoryRequirements:            vk.ProcGetBufferMemoryRequirements,
	vkGetImageMemoryRequirements:             vk.ProcGetImageMemoryRequirements,
	vkGetImageSubresourceLayout:              vk.ProcGetImageSubresourceLayout,
	vkGetPhysicalDeviceImageFormatProperties: vk.ProcGetPhysicalDeviceImageFormatProperties,
	vkGetPhysicalDeviceFormatProperties:      vk.ProcGetPhysicalDeviceFormatProperties,
	vkGetPhysicalDeviceMemoryProperties:      vk.ProcGetPhysicalDeviceMemoryProperties,
	vkMapMemory:                              vk.ProcMapMemory,
	vkQueueSubmit:                            vk.ProcQueueSubmit,
	vkQueueWaitIdle:                          vk.ProcQueueWaitIdle,
	vkUnmapMemory:                            vk.ProcUnmapMemory,
	vkWaitForFences:                          vk.ProcWaitForFences,
}

/**
 * @class VulkanTexture
 * @brief Struct for returning information about the Vulkan texture image
 *        created by the ktxTexture_VkUpload* functions.
 *
 * Creation of these objects is internal to the upload functions.
 */
VulkanTexture :: struct {
	vkDestroyImage: vk.ProcDestroyImage,
	vkFreeMemory:   vk.ProcFreeMemory,
	image:          vk.Image,
	imageFormat:    vk.Format,
	imageLayout:    vk.ImageLayout,
	deviceMemory:   vk.DeviceMemory,
	viewType:       vk.ImageViewType,
	width:          u32,
	height:         u32,
	depth:          u32,
	levelCount:     u32,
	layerCount:     u32,
	allocationId:   u64,
}


/**
 * @class VulkanTexture_subAllocatorCallbacks
 * @brief Struct that contains all callbacks necessary for suballocation.
 *
 * These pointers must all be provided for upload or destroy to occur using suballocator callbacks.
 */
VulkanTexture_subAllocatorCallbacks :: struct {
	allocMemFuncPtr:    VulkanTexture_subAllocatorAllocMemFuncPtr, /*!< Pointer to the memory procurement function. Can suballocate one or more pages. */
	bindBufferFuncPtr:  VulkanTexture_subAllocatorBindBufferFuncPtr, /*!< Pointer to bind-buffer-to-suballocation(s) function. */
	bindImageFuncPtr:   VulkanTexture_subAllocatorBindImageFuncPtr, /*!< Pointer to bind-image-to-suballocation(s) function. */
	memoryMapFuncPtr:   VulkanTexture_subAllocatorMemoryMapFuncPtr, /*!< Pointer to function for mapping the memory of a specific page. */
	memoryUnmapFuncPtr: VulkanTexture_subAllocatorMemoryUnmapFuncPtr, /*!< Pointer to function for unmapping the memory of a specific page. */
	freeMemFuncPtr:     VulkanTexture_subAllocatorFreeMemFuncPtr, /*!< Pointer to the free procurement function. */
}


/**
 * @class VulkanDeviceInfo
 * @brief Struct for passing information about the Vulkan device on which
 *        to create images to the texture image loading functions.
 *
 * Avoids passing a large number of parameters to each loading function.
 * Use of ktxVulkanDeviceInfo_create() or ktxVulkanDeviceInfo_construct() to
 * populate this structure is highly recommended.
 *
 */
VulkanDeviceInfo :: struct {
	instance:               vk.Instance, /*!< Instance used to communicate with vulkan. */
	physicalDevice:         vk.PhysicalDevice, /*!< Handle of the physical device. */
	device:                 vk.Device, /*!< Handle of the logical device. */
	queue:                  vk.Queue, /*!< Handle to the queue to which to submit commands. */
	cmdBuffer:              vk.CommandBuffer, /*!< Handle of the cmdBuffer to use. */
	cmdPool:                vk.CommandPool,
	pAllocator:             ^vk.AllocationCallbacks,
	deviceMemoryProperties: vk.PhysicalDeviceMemoryProperties,
	vkFuncs:                VulkanFunctions,
}
