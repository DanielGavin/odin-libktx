package libktx


import "core:c"
import vk "vendor:vulkan"

when ODIN_OS == .Windows {
	foreign import ktx "external/ktx.lib"
} else {

}

/**
 * @brief type for a pointer to a stream reading function
 */
Stream_read :: proc "c" (str: ^Stream, dst: rawptr, count: c.size_t) -> error_code_e

/**
* @brief type for a pointer to a stream skipping function
*/
Stream_skip :: proc "c" (str: ^Stream, count: c.size_t) -> error_code_e

/**
* @brief type for a pointer to a stream writing function
*/
Stream_write :: proc "c" (
	str: ^Stream,
	src: rawptr,
	size: c.size_t,
	count: c.size_t,
) -> error_code_e

/**
* @brief type for a pointer to a stream position query function
*/
Stream_getpos :: proc "c" (str: ^Stream, offset: ^c.size_t) -> error_code_e


/**
* @brief type for a pointer to a stream position query function
*/
Stream_setpos :: proc "c" (str: ^Stream, offset: c.size_t) -> error_code_e

/**
* @brief type for a pointer to a stream size query function
*/
Stream_getsize :: proc "c" (str: ^Stream, size: ^c.size_t) -> error_code_e

/**
* @brief Destruct a stream
*/
Stream_destruct :: proc "c" (str: ^Stream)

PFNKTXITERCB :: proc "c" (
	mipLevel: i32,
	face: i32,
	width: i32,
	height: i32,
	depth: i32,
	faceLodSize: u64,
	pixels: rawptr,
	userdata: rawptr,
)

PFNKTEXSETIMAGEFROMMEMORY :: proc "c" (
	This: ^Texture,
	level: u32,
	layer: u32,
	faceSlice: u32,
	src: [^]u8,
	srcSize: c.size_t,
) -> error_code

PFNKTEXDESTROY :: proc "c" (This: ^Texture)

PFNKTEXGETIMAGEOFFSET :: proc "c" (
	This: ^Texture,
	level: u32,
	layer: u32,
	faceSlice: u32,
	pOffset: ^c.size_t,
) -> error_code

PFNKTEXGETDATASIZEUNCOMPRESSED :: proc "c" (This: ^Texture) -> c.size_t
PFNKTEXGETIMAGESIZE :: proc "c" (This: ^Texture, level: u32) -> c.size_t
PFNKTEXITERATELEVELS :: proc "c" (
	This: ^Texture,
	iterCb: PFNKTXITERCB,
	userdata: rawptr,
) -> error_code

PFNKTEXITERATELOADLEVELFACES :: proc "c" (
	This: ^Texture,
	iterCb: PFNKTXITERCB,
	userdata: rawptr,
) -> error_code

PFNKTEXLOADIMAGEDATA :: proc "c" (This: ^Texture, pBuffer: [^]u8, bufSize: c.size_t) -> error_code
PFNKTEXNEEDSTRANSCODING :: proc "c" (This: ^Texture) -> b32
PFNKTEXWRITETONAMEDFILE :: proc "c" (This: ^Texture, dstname: cstring) -> error_code
PFNKTEXWRITETOMEMORY :: proc "c" (This: ^Texture, bytes: ^[^]u8, size: ^c.size_t) -> error_code
PFNKTEXWRITETOSTREAM :: proc "c" (This: ^Texture, dststr: ^Stream) -> error_code


Texture_SetImageFromMemory :: proc(
	This: ^Texture,
	level: u32,
	layer: u32,
	faceSlice: u32,
	src: [^]u8,
	srcSize: c.size_t,
) -> error_code {
	return This.vtbl.SetImageFromMemory(This, level, layer, faceSlice, src, srcSize)
}

Texture_WriteToNamedFile :: proc(This: ^Texture, dstname: cstring) -> error_code {
	return This.vtbl.WriteToNamedFile(This, dstname)
}

Texture_WriteToMemory :: proc(This: ^Texture, bytes: ^[^]u8, size: ^c.size_t) -> error_code {
	return This.vtbl.WriteToMemory(This, bytes, size)
}

Texture_WriteToStream :: proc(This: ^Texture, dststr: ^Stream) -> error_code {
	return This.vtbl.WriteToStream(This, dststr)
}

VulkanTexture_subAllocatorAllocMemFuncPtr :: proc "c" (
	allocInfo: ^vk.MemoryAllocateInfo,
	memReg: ^vk.MemoryRequirements,
	pageCount: ^u64,
) -> u64

VulkanTexture_subAllocatorBindBufferFuncPtr :: proc "c" (
	buffer: vk.Buffer,
	allocId: u64,
) -> vk.Result

VulkanTexture_subAllocatorBindImageFuncPtr :: proc "c" (image: vk.Image, allocId: u64) -> vk.Result

VulkanTexture_subAllocatorMemoryMapFuncPtr :: proc "c" (
	allocId: u64,
	pageNumber: u64,
	mapLength: ^vk.DeviceSize,
	dataPtr: ^rawptr,
) -> vk.Result


VulkanTexture_subAllocatorMemoryUnmapFuncPtr :: proc "c" (allocId: u64, pageNumber: u64)

VulkanTexture_subAllocatorFreeMemFuncPtr :: proc "c" (allocId: u64)


@(link_prefix = "ktx")
foreign ktx {
	Texture_CreateFromNamedFile :: proc(filename: cstring, createFlags: TextureCreateFlags, newTex: ^^Texture) -> error_code ---
	Texture_CreateFromMemory :: proc(bytes: [^]u8, size: c.size_t, createFlags: TextureCreateFlags, newTex: ^^Texture) -> error_code ---
	Texture_CreateFromStream :: proc(stream: Stream, createFlags: TextureCreateFlags, newTex: ^^Texture) -> error_code ---

	Texture_GetData :: proc(This: ^Texture) -> [^]u8 ---
	Texture_GetRowPitch :: proc(This: ^Texture, level: u32) -> u32 ---
	Texture_GetElementSize :: proc(This: ^Texture) -> u32 ---
	Texture_GetDataSize :: proc(This: ^Texture) -> c.size_t ---
	Texture_IterateLevelFaces :: proc(This: ^Texture, iterCb: PFNKTXITERCB, userdata: rawptr) -> error_code ---

	Texture1_Create :: proc(createInfo: ^TextureCreateInfo, storageAllocation: TextureCreateStorageEnum, newTex: ^^Texture1) -> error_code ---
	Texture1_CreateFromNamedFile :: proc(filename: cstring, createFlags: TextureCreateFlags, newTex: ^^Texture1) -> error_code ---
	Texture1_CreateFromMemory :: proc(bytes: [^]u8, size: c.size_t, createFlags: TextureCreateFlags, newTex: ^^Texture1) -> error_code ---
	Texture1_CreateFromStream :: proc(stream: Stream, createFlags: TextureCreateFlags, newTex: ^^Texture1) -> error_code ---
	Texture1_NeedsTranscoding :: proc(This: ^Texture1) -> b32 ---
	Texture1_WriteKTX2ToNamedFile :: proc(This: ^Texture1, dstname: cstring) -> error_code ---
	Texture1_WriteKTX2ToMemory :: proc(This: ^Texture1, bytes: ^[^]u8, size: ^c.size_t) -> error_code ---
	Texture1_WriteKTX2ToStream :: proc(This: ^Texture1, dststr: ^Stream) -> error_code ---


	Texture2_Create :: proc(createInfo: ^TextureCreateInfo, storageAllocation: TextureCreateStorageEnum, newTex: ^^Texture2) -> error_code ---
	Texture2_CreateFromNamedFile :: proc(filename: cstring, createFlags: TextureCreateFlags, newTex: ^^Texture2) -> error_code ---
	Texture2_CreateFromMemory :: proc(bytes: [^]u8, size: c.size_t, createFlags: TextureCreateFlags, newTex: ^^Texture2) -> error_code ---
	Texture2_CreateFromStream :: proc(stream: Stream, createFlags: TextureCreateFlags, newTex: ^^Texture2) -> error_code ---
	Texture2_CreateCopy :: proc(orig: ^Texture2, newTex: ^^Texture2) -> error_code ---


	Texture2_CompressBasis :: proc(This: ^Texture2, quality: u32) -> error_code ---
	Texture2_DeflateZstd :: proc(This: ^Texture2, level: u32) -> error_code ---
	Texture2_DeflateZLIB :: proc(This: ^Texture2, level: u32) -> error_code ---
	Texture2_GetComponentInfo :: proc(This: ^Texture2, numComponents: ^u32, componentByteLength: ^u32) ---
	Texture2_GetNumComponents :: proc(This: ^Texture2) -> u32 ---
	Texture2_GetOETF :: proc(This: ^Texture2) -> u32 ---
	Texture2_GetPremultipliedAlpha :: proc(This: ^Texture2) -> b32 ---
	Texture2_NeedsTranscoding :: proc(This: ^Texture2) -> b32 ---

	Texture2_CompressAstcEx :: proc(This: ^Texture2, params: ^AstcParams) -> error_code ---
	Texture2_CompressAstc :: proc(This: ^Texture2, quality: u32) -> error_code ---
	Texture2_CompressBasisEx :: proc(This: ^Texture2, params: ^BasisParams) -> error_code ---
	Texture2_TranscodeBasis :: proc(This: ^Texture2, _fmt: transcode_fmt_e, transcodeFlags: transcode_flags) -> error_code ---

	PrintInfoForNamedFile :: proc(filename: cstring) -> error_code ---
	PrintInfoForMemory :: proc(bytes: [^]u8, size: c.size_t) -> error_code ---

	PrintKTX2InfoTextForNamedFile :: proc(filename: cstring) -> error_code ---
	PrintKTX2InfoTextForMemory :: proc(bytes: [^]u8, size: c.size_t) -> error_code ---
	PrintKTX2InfoTextForStream :: proc(bytes: [^]u8, size: c.size_t, base_ident: u32, ident_width: u32, minified: b32) -> error_code ---
	PrintKTX2InfoJSONForNamedFile :: proc(filename: cstring, base_ident: u32, ident_width: u32, minified: b32) -> error_code ---
	PrintKTX2InfoJSONForStream :: proc(stream: ^Stream, base_ident: u32, ident_width: u32, minified: b32) -> error_code ---


	ErrorString :: proc(error: error_code) -> cstring ---
	SupercompressionSchemeString :: proc(scheme: SupercmpScheme) -> cstring ---
	TranscodeFormatString :: proc(format: transcode_flag_bits_e) -> cstring ---

	HashList_Create :: proc(ppHl: ^^HashList) ---
	HashList_CreateCopy :: proc(ppHl: ^^HashList, orig: HashList) ---
	HashList_ConstructCopy :: proc(ppHl: ^HashList, orig: HashList) ---
	HashList_Destroy :: proc(head: ^HashList) ---
	HashList_Destruct :: proc(head: ^HashList) ---
	HashList_AddKVPair :: proc(head: ^HashList, key: cstring, valueLen: u32, value: rawptr) -> error_code ---
	HashList_DeleteEntry :: proc(pHead: ^HashList, pEntry: ^HashListEntry) -> error_code ---
	HashList_DeleteKVPair :: proc(pHead: ^HashList, key: cstring) -> error_code ---
	HashList_FindEntry :: proc(pHead: ^HashList, key: cstring, ppEntry: ^^HashListEntry) -> error_code ---
	HashList_FindValue :: proc(pHead: ^HashList, key: cstring, pValueLen: ^u32, pValue: ^rawptr) -> error_code ---
	HashList_Next :: proc(entry: ^HashListEntry) -> error_code ---
	HashList_Sort :: proc(pHead: ^HashListEntry) -> error_code ---
	HashList_Serialize :: proc(pHead: ^HashList, kvdLen: ^u32, kvd: ^cstring) -> error_code ---
	HashList_Deserialize :: proc(pHead: ^HashList, kvdLen: u32, kvd: rawptr) -> error_code ---
	HashListEntry_GetKey :: proc(This: HashListEntry, pKeyLen: ^u32, ppKey: ^^u8) -> error_code ---
	HashListEntry_GetValue :: proc(This: HashListEntry, pValueLen: ^u32, ppValue: ^rawptr) -> error_code ---

	VulkanTexture_Destruct_WithSuballocator :: proc(This: ^VulkanTexture, device: vk.Device, pAllocator: ^vk.AllocationCallbacks, subAllocatorCallbacks: ^VulkanTexture_subAllocatorCallbacks) -> error_code ---
	VulkanTexture_Destruct :: proc(This: ^VulkanTexture, device: vk.Device, pAllocator: ^vk.AllocationCallbacks) ---

	VulkanDeviceInfo_CreateEx :: proc(instance: vk.Instance, physicalDevice: vk.PhysicalDevice, device: vk.Device, queue: vk.Queue, cmdPool: vk.CommandPool, pAllocator: ^vk.AllocationCallbacks, pFunctions: ^VulkanFunctions) -> ^VulkanDeviceInfo ---
	VulkanDeviceInfo_Create :: proc(physicalDevice: vk.PhysicalDevice, device: vk.Device, queue: vk.Queue, cmdPool: vk.CommandPool, pAllocator: ^vk.AllocationCallbacks) -> ^VulkanDeviceInfo ---

	VulkanDeviceInfo_Construct :: proc(This: ^VulkanDeviceInfo, physicalDevice: vk.PhysicalDevice, device: vk.Device, queue: vk.Queue, cmdPool: vk.CommandPool, pAllocator: ^vk.AllocationCallbacks) -> error_code ---
	VulkanDeviceInfo_ConstructEx :: proc(This: ^VulkanDeviceInfo, instance: vk.Instance, physicalDevice: vk.PhysicalDevice, device: vk.Device, queue: vk.Queue, cmdPool: vk.CommandPool, pAllocator: ^vk.AllocationCallbacks, pFunctions: ^VulkanFunctions) -> error_code ---

	VulkanDeviceInfo_Destruct :: proc(This: ^VulkanDeviceInfo) ---
	VulkanDeviceInfo_Destroy :: proc(This: ^VulkanDeviceInfo) ---

	Texture_VkUploadEx_WithSuballocator :: proc(This: ^Texture, vdi: ^VulkanDeviceInfo, vkTexture: ^VulkanTexture, tilling: vk.ImageTiling, usageFlags: vk.ImageUsageFlags, finalLayout: vk.ImageLayout, subAllocatorCallbacks: ^VulkanTexture_subAllocatorCallbacks) -> error_code ---
	Texture_VkUploadEx :: proc(This: ^Texture, vdi: ^VulkanDeviceInfo, vkTexture: ^VulkanTexture, tilling: vk.ImageTiling, usageFlags: vk.ImageUsageFlags, finalLayout: vk.ImageLayout) -> error_code ---
	Texture_VkUpload :: proc(This: ^Texture, vdi: ^VulkanDeviceInfo, vkTexture: ^VulkanTexture) -> error_code ---

	Texture1_VkUploadEx_WithSuballocator :: proc(This: ^Texture1, vdi: ^VulkanDeviceInfo, vkTexture: ^VulkanTexture, tilling: vk.ImageTiling, usageFlags: vk.ImageUsageFlags, finalLayout: vk.ImageLayout, subAllocatorCallbacks: ^VulkanTexture_subAllocatorCallbacks) -> error_code ---
	Texture1_VkUploadEx :: proc(This: ^Texture1, vdi: ^VulkanDeviceInfo, vkTexture: ^VulkanTexture, tilling: vk.ImageTiling, usageFlags: vk.ImageUsageFlags, finalLayout: vk.ImageLayout) -> error_code ---
	Texture1_VkUpload :: proc(This: ^Texture1, vdi: ^VulkanDeviceInfo, vkTexture: ^VulkanTexture) -> error_code ---

	Texture2_VkUploadEx_WithSuballocator :: proc(This: ^Texture2, vdi: ^VulkanDeviceInfo, vkTexture: ^VulkanTexture, tilling: vk.ImageTiling, usageFlags: vk.ImageUsageFlags, finalLayout: vk.ImageLayout, subAllocatorCallbacks: ^VulkanTexture_subAllocatorCallbacks) -> error_code ---
	Texture2_VkUploadEx :: proc(This: ^Texture2, vdi: ^VulkanDeviceInfo, vkTexture: ^VulkanTexture, tilling: vk.ImageTiling, usageFlags: vk.ImageUsageFlags, finalLayout: vk.ImageLayout) -> error_code ---
	Texture2_VkUpload :: proc(This: ^Texture2, vdi: ^VulkanDeviceInfo, vkTexture: ^VulkanTexture) -> error_code ---

	Texture_GetVkFormat :: proc(This: ^Texture) -> vk.Format ---
	Texture1_GetVkFormat :: proc(This: ^Texture1) -> vk.Format ---
	Texture2_GetVkFormat :: proc(This: ^Texture2) -> vk.Format ---
}


create_vulkan_functions :: proc() -> VulkanFunctions {
	return(
		VulkanFunctions {
			vkGetInstanceProcAddr = vk.GetInstanceProcAddr,
			vkGetDeviceProcAddr = vk.GetDeviceProcAddr,
			vkAllocateCommandBuffers = vk.AllocateCommandBuffers,
			vkAllocateMemory = vk.AllocateMemory,
			vkBeginCommandBuffer = vk.BeginCommandBuffer,
			vkBindBufferMemory = vk.BindBufferMemory,
			vkBindImageMemory = vk.BindImageMemory,
			vkCmdBlitImage = vk.CmdBlitImage,
			vkCmdCopyBufferToImage = vk.CmdCopyBufferToImage,
			vkCmdPipelineBarrier = vk.CmdPipelineBarrier,
			vkCreateImage = vk.CreateImage,
			vkDestroyImage = vk.DestroyImage,
			vkCreateBuffer = vk.CreateBuffer,
			vkDestroyBuffer = vk.DestroyBuffer,
			vkCreateFence = vk.CreateFence,
			vkDestroyFence = vk.DestroyFence,
			vkEndCommandBuffer = vk.EndCommandBuffer,
			vkFreeCommandBuffers = vk.FreeCommandBuffers,
			vkFreeMemory = vk.FreeMemory,
			vkGetBufferMemoryRequirements = vk.GetBufferMemoryRequirements,
			vkGetImageMemoryRequirements = vk.GetImageMemoryRequirements,
			vkGetImageSubresourceLayout = vk.GetImageSubresourceLayout,
			vkGetPhysicalDeviceImageFormatProperties = vk.GetPhysicalDeviceImageFormatProperties,
			vkGetPhysicalDeviceFormatProperties = vk.GetPhysicalDeviceFormatProperties,
			vkGetPhysicalDeviceMemoryProperties = vk.GetPhysicalDeviceMemoryProperties,
			vkMapMemory = vk.MapMemory,
			vkQueueSubmit = vk.QueueSubmit,
			vkQueueWaitIdle = vk.QueueWaitIdle,
			vkUnmapMemory = vk.UnmapMemory,
			vkWaitForFences = vk.WaitForFences,
		} \
	)
}
