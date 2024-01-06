package libktx

error_code_e :: enum {
	SUCCESS = 0, // Operation was successful. 
	FILE_DATA_ERROR, // The data in the file is inconsistent with the spec. 
	FILE_ISPIPE, // The file is a pipe or named pipe. 
	FILE_OPEN_FAILED, // The target file could not be opened. 
	FILE_OVERFLOW, // The operation would exceed the max file size. 
	FILE_READ_ERROR, // An error occurred while reading from the file. 
	FILE_SEEK_ERROR, // An error occurred while seeking in the file. 
	FILE_UNEXPECTED_EOF, // File does not have enough data to satisfy request. 
	FILE_WRITE_ERROR, // An error occurred while writing to the file. 
	GL_ERROR, // GL operations resulted in an error. 
	INVALID_OPERATION, // The operation is not allowed in the current state. 
	INVALID_VALUE, // A parameter value was not valid. 
	NOT_FOUND, // Requested metadata key or required dynamically loaded GPU function was not found. */
	OUT_OF_MEMORY, // Not enough memory to complete the operation. 
	TRANSCODE_FAILED, // Transcoding of block compressed texture failed. 
	UNKNOWN_FILE_FORMAT, // The file not a KTX file 
	UNSUPPORTED_TEXTURE_TYPE, // The KTX file specifies an unsupported texture type. 
	UNSUPPORTED_FEATURE, // Feature not included in in-use library or not yet implemented. 
	LIBRARY_NOT_LINKED, //  Library dependency (OpenGL or Vulkan) not linked into application. 
	DECOMPRESS_LENGTH_ERROR, // Decompressed byte count does not match expected byte size */
	DECOMPRESS_CHECKSUM_ERROR, // Checksum mismatch when decompressing 
	ERROR_MAX_ENUM = DECOMPRESS_CHECKSUM_ERROR, // For safety checks. 
}

Result :: error_code_e

error_code :: error_code_e


OrientationX :: enum {
	KTX_ORIENT_X_LEFT  = 'l',
	KTX_ORIENT_X_RIGHT = 'r',
}

OrientationY :: enum {
	KTX_ORIENT_Y_UP   = 'u',
	KTX_ORIENT_Y_DOWN = 'd',
}

OrientationZ :: enum {
	KTX_ORIENT_Z_IN  = 'i',
	KTX_ORIENT_Z_OUT = 'o',
}

class_id :: enum {
	ktxTexture1_c = 1,
	ktxTexture2_c = 2,
}

/**
 * @brief Enumerators identifying the supercompression scheme.
 */
SupercmpScheme :: enum {
	KTX_SS_NONE               = 0, // No supercompression. 
	KTX_SS_BASIS_LZ           = 1, // Basis LZ supercompression. 
	KTX_SS_ZSTD               = 2, // ZStd supercompression. 
	KTX_SS_ZLIB               = 3, // ZLIB supercompression. 
	KTX_SS_BEGIN_RANGE        = KTX_SS_NONE,
	KTX_SS_END_RANGE          = KTX_SS_ZLIB,
	KTX_SS_BEGIN_VENDOR_RANGE = 0x10000,
	KTX_SS_END_VENDOR_RANGE   = 0x1ffff,
	KTX_SS_BEGIN_RESERVED     = 0x20000,
}


/**
 * @memberof ktxTexture
 * @brief Enum for requesting, or not, allocation of storage for images.
 *
 * @sa ktxTexture1_Create() and ktxTexture2_Create().
 */
TextureCreateStorageEnum :: enum {
	TEXTURE_CREATE_NO_STORAGE    = 0, // Don't allocate any image storage. 
	TEXTURE_CREATE_ALLOC_STORAGE = 1, // Allocate image storage. 
}


/**
 * @memberof ktxTexture
 * @brief Flags for requesting services during creation.
 *
 * @sa ktxTexture_CreateFrom*
 */
TextureCreateFlagBit :: enum {
	KTX_TEXTURE_CREATE_NO_FLAGS              = 0,
	KTX_TEXTURE_CREATE_LOAD_IMAGE_DATA_BIT   = 1, //Load the images from the KTX source. 
	KTX_TEXTURE_CREATE_RAW_KVDATA_BIT        = 2, //Load the raw key-value data instead of creating a @c ktxHashList from it. 
	KTX_TEXTURE_CREATE_SKIP_KVDATA_BIT       = 3, // Skip any key-value data. This overrides the RAW_KVDATA_BIT. 
	KTX_TEXTURE_CREATE_CHECK_GLTF_BASISU_BIT = 4, // Load texture compatible with the rulesof KHR_texture_basisu glTF extension 
}

TextureCreateFlags :: distinct bit_set[TextureCreateFlagBit;u32]


/**
 * @brief Flags specifiying UASTC encoding options.
 */
pack_uastc_flag_bits_e :: enum {
	PACK_UASTC_LEVEL_FASTEST                     = 0, // Fastest compression. 43.45dB. 
	PACK_UASTC_LEVEL_FASTER                      = 1, // Faster compression. 46.49dB. 
	PACK_UASTC_LEVEL_DEFAULT                     = 2, // Default compression. 47.47dB. 
	PACK_UASTC_LEVEL_SLOWER                      = 3, // Slower compression. 48.01dB. 
	PACK_UASTC_LEVEL_VERYSLOW                    = 4, // Very slow compression. 48.24dB. 
	PACK_UASTC_MAX_LEVEL                         = PACK_UASTC_LEVEL_VERYSLOW, // Maximum supported quality level. 
	PACK_UASTC_LEVEL_MASK                        = 0xF, // Mask to extract the level from the other bits. 
	PACK_UASTC_FAVOR_UASTC_ERROR                 = 8, // Optimize for lowest UASTC error. 
	PACK_UASTC_FAVOR_BC7_ERROR                   = 16, // Optimize for lowest BC7 error. 
	PACK_UASTC_ETC1_FASTER_HINTS                 = 64, // Optimize for faster transcoding to ETC1. 
	PACK_UASTC_ETC1_FASTEST_HINTS                = 128, // Optimize for fastest transcoding to ETC1. 
	PACK_UASTC__ETC1_DISABLE_FLIP_AND_INDIVIDUAL = 256, // Not documented in BasisU code. 
}

pack_uastc_flags :: pack_uastc_flag_bits_e


/**
 * @brief Options specifiying ASTC encoding quality levels.
 */
pack_astc_quality_levels_e :: enum {
	PACK_ASTC_QUALITY_LEVEL_FASTEST    = 0, //Fastest compression.
	PACK_ASTC_QUALITY_LEVEL_FAST       = 10, // Fast compression. 
	PACK_ASTC_QUALITY_LEVEL_MEDIUM     = 60, // Medium compression.
	PACK_ASTC_QUALITY_LEVEL_THOROUGH   = 98, // Slower compression.
	PACK_ASTC_QUALITY_LEVEL_EXHAUSTIVE = 100, // Very slow compression
	PACK_ASTC_QUALITY_LEVEL_MAX        = PACK_ASTC_QUALITY_LEVEL_EXHAUSTIVE, // Maximum supported quality level. 
}


/**
 * @brief Options specifiying ASTC encoding block dimensions
 */
pack_astc_block_dimension_e :: enum {
	// 2D formats
	PACK_ASTC_BLOCK_DIMENSION_4x4, //: 8.00 bpp
	PACK_ASTC_BLOCK_DIMENSION_5x4, //: 6.40 bpp
	PACK_ASTC_BLOCK_DIMENSION_5x5, //: 5.12 bpp
	PACK_ASTC_BLOCK_DIMENSION_6x5, //: 4.27 bpp
	PACK_ASTC_BLOCK_DIMENSION_6x6, //: 3.56 bpp
	PACK_ASTC_BLOCK_DIMENSION_8x5, //: 3.20 bpp
	PACK_ASTC_BLOCK_DIMENSION_8x6, //: 2.67 bpp
	PACK_ASTC_BLOCK_DIMENSION_10x5, //: 2.56 bpp
	PACK_ASTC_BLOCK_DIMENSION_10x6, //: 2.13 bpp
	PACK_ASTC_BLOCK_DIMENSION_8x8, //: 2.00 bpp
	PACK_ASTC_BLOCK_DIMENSION_10x8, //: 1.60 bpp
	PACK_ASTC_BLOCK_DIMENSION_10x10, //: 1.28 bpp
	PACK_ASTC_BLOCK_DIMENSION_12x10, //: 1.07 bpp
	PACK_ASTC_BLOCK_DIMENSION_12x12, //: 0.89 bpp
	// 3D formats
	PACK_ASTC_BLOCK_DIMENSION_3x3x3, //: 4.74 bpp
	PACK_ASTC_BLOCK_DIMENSION_4x3x3, //: 3.56 bpp
	PACK_ASTC_BLOCK_DIMENSION_4x4x3, //: 2.67 bpp
	PACK_ASTC_BLOCK_DIMENSION_4x4x4, //: 2.00 bpp
	PACK_ASTC_BLOCK_DIMENSION_5x4x4, //: 1.60 bpp
	PACK_ASTC_BLOCK_DIMENSION_5x5x4, //: 1.28 bpp
	PACK_ASTC_BLOCK_DIMENSION_5x5x5, //: 1.02 bpp
	PACK_ASTC_BLOCK_DIMENSION_6x5x5, //: 0.85 bpp
	PACK_ASTC_BLOCK_DIMENSION_6x6x5, //: 0.71 bpp
	PACK_ASTC_BLOCK_DIMENSION_6x6x6, //: 0.59 bpp
	PACK_ASTC_BLOCK_DIMENSION_MAX = PACK_ASTC_BLOCK_DIMENSION_6x6x6, // Maximum supported blocks. 
}


/**
 * @brief Options specifying ASTC encoder profile mode
 *        This and function is used later to derive the profile.
 */
pack_astc_encoder_mode_e :: enum {
	PACK_ASTC_ENCODER_MODE_DEFAULT,
	PACK_ASTC_ENCODER_MODE_LDR,
	PACK_ASTC_ENCODER_MODE_HDR,
	PACK_ASTC_ENCODER_MODE_MAX = PACK_ASTC_ENCODER_MODE_HDR,
}


streamType :: enum {
	eStreamTypeFile   = 1,
	eStreamTypeMemory = 2,
	eStreamTypeCustom = 3,
}


/**
 * @brief Enumerators for specifying the transcode target format.
 *
 * For BasisU/ETC1S format, @e Opaque and @e alpha here refer to 2 separate
 * RGB images, a.k.a slices within the BasisU compressed data. For UASTC
 * format they refer to the RGB and the alpha components of the UASTC data. If
 * the original image had only 2 components, R will be in the opaque portion
 * and G in the alpha portion. The R value will be replicated in the RGB
 * components. In the case of BasisU the G value will be replicated in all 3
 * components of the alpha slice. If the original image had only 1 component
 * it's value is replicated in all 3 components of the opaque portion and
 * there is no alpha.
 *
 * @note You should not transcode sRGB encoded data to @c KTX_TTF_BC4_R,
 * @c KTX_TTF_BC5_RG, @c KTX_TTF_ETC2_EAC_R{,G}11, @c KTX_TTF_RGB565,
 * @c KTX_TTF_BGR565 or @c KTX_TTF_RGBA4444 formats as neither OpenGL nor
 * Vulkan support sRGB variants of these. Doing sRGB decoding in the shader
 * will not produce correct results if any texture filtering is being used.
 */
transcode_fmt_e :: enum {
	// Compressed formats

	// ETC1-2
	TTF_ETC1_RGB            = 0,
	/*!< Opaque only. Returns RGB or alpha data, if
			 KTX_TF_TRANSCODE_ALPHA_DATA_TO_OPAQUE_FORMATS flag is
			 specified. */
	TTF_ETC2_RGBA           = 1,
	/*!< Opaque+alpha. EAC_A8 block followed by an ETC1 block. The
			 alpha channel will be opaque for textures without an alpha
			 channel. */

	// BC1-5, BC7 (desktop, some mobile devices)
	TTF_BC1_RGB             = 2,
	/*!< Opaque only, no punchthrough alpha support yet.  Returns RGB
		 or alpha data, if KTX_TF_TRANSCODE_ALPHA_DATA_TO_OPAQUE_FORMATS
		 flag is specified. */
	TTF_BC3_RGBA            = 3,
	/*!< Opaque+alpha. BC4 block with alpha followed by a BC1 block. The
		 alpha channel will be opaque for textures without an alpha
		 channel. */
	TTF_BC4_R               = 4,
	/*!< One BC4 block. R = opaque.g or alpha.g, if
		 KTX_TF_TRANSCODE_ALPHA_DATA_TO_OPAQUE_FORMATS flag is
		 specified. */
	TTF_BC5_RG              = 5,
	/*!< Two BC4 blocks, R=opaque.g and G=alpha.g The texture should
		 have an alpha channel (if not G will be all 255's. For tangent
		 space normal maps. */
	TTF_BC7_RGBA            = 6,
	/*!< RGB or RGBA mode 5 for ETC1S, modes 1, 2, 3, 4, 5, 6, 7 for
			 UASTC. */

	// PVRTC1 4bpp (mobile, PowerVR devices)
	TTF_PVRTC1_4_RGB        = 8,
	/*!< Opaque only. Returns RGB or alpha data, if
			 KTX_TF_TRANSCODE_ALPHA_DATA_TO_OPAQUE_FORMATS flag is
			 specified. */
	TTF_PVRTC1_4_RGBA       = 9,
	/*!< Opaque+alpha. Most useful for simple opacity maps. If the
			 texture doesn't have an alpha channel KTX_TTF_PVRTC1_4_RGB
			 will be used instead. Lowest quality of any supported
			 texture format. */

	// ASTC (mobile, Intel devices, hopefully all desktop GPU's one day)
	TTF_ASTC_4x4_RGBA       = 10,
	/*!< Opaque+alpha, ASTC 4x4. The alpha channel will be opaque for
			 textures without an alpha channel.  The transcoder uses
			 RGB/RGBA/L/LA modes, void extent, and up to two ([0,47] and
			 [0,255]) endpoint precisions. */

	// ATC and FXT1 formats are not supported by KTX2 as there
	// are no equivalent VkFormats.
	TTF_PVRTC2_4_RGB        = 18,
	/*!< Opaque-only. Almost BC1 quality, much faster to transcode
		 and supports arbitrary texture dimensions (unlike
		 PVRTC1 RGB). */
	TTF_PVRTC2_4_RGBA       = 19,
	/*!< Opaque+alpha. Slower to transcode than cTFPVRTC2_4_RGB.
		 Premultiplied alpha is highly recommended, otherwise the
		 color channel can leak into the alpha channel on transparent
		 blocks. */
	TTF_ETC2_EAC_R11        = 20,
	/*!< R only (ETC2 EAC R11 unsigned). R = opaque.g or alpha.g, if
		 KTX_TF_TRANSCODE_ALPHA_DATA_TO_OPAQUE_FORMATS flag is
		 specified. */
	TTF_ETC2_EAC_RG11       = 21,
	/*!< RG only (ETC2 EAC RG11 unsigned), R=opaque.g, G=alpha.g. The
			 texture should have an alpha channel (if not G will be all
			 255's. For tangent space normal maps. */

	// Uncompressed (raw pixel) formats
	TTF_RGBA32              = 13,
	/*!< 32bpp RGBA image stored in raster (not block) order in
		 memory, R is first byte, A is last byte. */
	TTF_RGB565              = 14,
	/*!< 16bpp RGB image stored in raster (not block) order in memory,
		 R at bit position 11. */
	TTF_BGR565              = 15,
	/*!< 16bpp RGB image stored in raster (not block) order in memory,
		 R at bit position 0. */
	TTF_RGBA4444            = 16,
	/*!< 16bpp RGBA image stored in raster (not block) order in memory,
			 R at bit position 12, A at bit position 0. */

	// Values for automatic selection of RGB or RGBA depending if alpha
	// present.
	TTF_ETC                 = 22,
	/*!< Automatically selects @c KTX_TTF_ETC1_RGB or
		 @c KTX_TTF_ETC2_RGBA according to presence of alpha. */
	TTF_BC1_OR_3            = 23,
	/*!< Automatically selects @c KTX_TTF_BC1_RGB or
		 @c KTX_TTF_BC3_RGBA according to presence of alpha. */
	TTF_NOSELECTION         = 0x7fffffff,

	// Old enums for compatibility with code compiled against previous
	// versions of libktx.
	TF_ETC1                 = TTF_ETC1_RGB,
	//!< @deprecated. Use #KTX_TTF_ETC1_RGB.
	TF_ETC2                 = TTF_ETC,
	//!< @deprecated. Use #KTX_TTF_ETC.
	TF_BC1                  = TTF_BC1_RGB,
	//!< @deprecated. Use #KTX_TTF_BC1_RGB.
	TF_BC3                  = TTF_BC3_RGBA,
	//!< @deprecated. Use #KTX_TTF_BC3_RGBA.
	TF_BC4                  = TTF_BC4_R,
	//!< @deprecated. Use #KTX_TTF_BC4_R.
	TF_BC5                  = TTF_BC5_RG,
	//!< @deprecated. Use #KTX_TTF_BC5_RG.
	TTF_BC7_M6_RGB          = TTF_BC7_RGBA,
	//!< @deprecated. Use #KTX_TTF_BC7_RGBA.
	TTF_BC7_M5_RGBA         = TTF_BC7_RGBA,
	//!< @deprecated. Use #KTX_TTF_BC7_RGBA.
	TF_BC7_M6_OPAQUE_ONLY   = TTF_BC7_RGBA,
	//!< @deprecated. Use #KTX_TTF_BC7_RGBA
	TF_PVRTC1_4_OPAQUE_ONLY = TTF_PVRTC1_4_RGB,
	//!< @deprecated. Use #KTX_TTF_PVRTC1_4_RGB.
}


/**
 * @brief Flags guiding transcoding of Basis Universal compressed textures.
 */
transcode_flag_bits_e :: enum {
	TF_PVRTC_DECODE_TO_NEXT_POW2              = 1,
	/*!< PVRTC1: decode non-pow2 ETC1S texture level to the next larger
             power of 2 (not implemented yet, but we're going to support it).
             Ignored if the slice's dimensions are already a power of 2.
         */
	TF_TRANSCODE_ALPHA_DATA_TO_OPAQUE_FORMATS = 2,
	/*!< When decoding to an opaque texture format, if the Basis data has
             alpha, decode the alpha slice instead of the color slice to the
             output texture format. Has no effect if there is no alpha data.
         */
	TF_HIGH_QUALITY                           = 5,
	/*!< Request higher quality transcode of UASTC to BC1, BC3, ETC2_EAC_R11 and
             ETC2_EAC_RG11. The flag is unused by other UASTC transcoders.
         */
}


transcode_flags :: distinct bit_set[transcode_flag_bits_e;u32]
