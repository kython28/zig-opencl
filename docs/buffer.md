## Creating a Buffer Object

### Description

The `create` function creates a buffer object in an OpenCL context. This buffer object can be used to store data that will be processed by an OpenCL device.

```zig
pub fn create(
    context: cl_context,
    flags: cl_mem_flags,
    size: usize,
    host_ptr: ?*anyopaque
) errors.opencl_error!cl_mem;
```

### Parameters

-   **context**: The `cl_context` in which the buffer object will be created.
-   **flags**: A bit-field used to specify allocation and usage information about the buffer memory object being created. These values can be obtained from the enum `buffer.enums.mem_flags` which contains mappings to OpenCL C enums. For example:
    -   `CL_MEM_WRITE_ONLY` -> `write_only`
    -   `CL_MEM_READ_WRITE` -> `read_write`
-   **size**: The size in bytes of the buffer memory object to be allocated.
-   **host_ptr**: A pointer to the buffer data that may already be allocated by the application. The size of the buffer that `host_ptr` points to must be greater than or equal to `size` bytes.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clCreateBuffer` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_context"`: The specified context is not valid.
-   `"invalid_value"`: Values specified in flags are not valid as defined in the Memory Flags table.
-   `"invalid_buffer_size"`: Size is 0, or if size is greater than `CL_DEVICE_MAX_MEM_ALLOC_SIZE` for all devices in context.
-   `"invalid_host_ptr"`: If `host_ptr` is NULL and `CL_MEM_USE_HOST_PTR` or `CL_MEM_COPY_HOST_PTR` are set in flags or if `host_ptr` is not NULL but `CL_MEM_COPY_HOST_PTR` or `CL_MEM_USE_HOST_PTR` are not set in flags.
-   `"mem_object_allocation_failure"`: There is a failure to allocate memory for the buffer object.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Reading from a Buffer

### Description

The `read` function reads data from an OpenCL buffer object to host memory. This function allows for both blocking and non-blocking reads.

```zig
pub fn read(
    command_queue: cl_command_queue,
    buffer: cl_mem,
    blocking_read: bool,
    offset: usize,
    size: usize,
    ptr: *anyopaque,
    event_wait_list: ?[]const cl_event,
    event: ?*cl_event
) errors.opencl_error!void;
```

### Parameters

-   **command_queue**: The `cl_command_queue` in which the read command will be queued.
-   **buffer**: Refers to a valid buffer object.
-   **blocking_read**: A boolean indicating if the read operation is blocking (`true`) or non-blocking (`false`).
-   **offset**: The offset in bytes in the buffer object to read from.
-   **size**: The size in bytes of data being read.
-   **ptr**: The pointer to buffer in host memory where data is to be read into.
-   **event_wait_list**: An optional list of events that need to complete before this particular command can be executed.
-   **event**: An optional event object that identifies this read command and can be used to query or queue a wait for this command to complete.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clEnqueueReadBuffer` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_command_queue"`: The specified command queue is not valid.
-   `"invalid_context"`: The context associated with the command queue and buffer are not the same, or the context associated with command queue and events in `event_wait_list` are not the same.
-   `"invalid_mem_object"`: The specified buffer is not a valid buffer object.
-   `"invalid_value"`: The region being read or written specified by (offset, size) is out of bounds or if `ptr` is a NULL value.
-   `"invalid_event_wait_list"`: The `event_wait_list` is NULL and `num_events_in_wait_list` > 0, or `event_wait_list` is not NULL and `num_events_in_wait_list` is 0, or if event objects in `event_wait_list` are not valid events.
-   `"misaligned_sub_buffer_offset"`: The buffer is a sub-buffer object, and the offset specified when the sub-buffer object is created is not aligned to `CL_DEVICE_MEM_BASE_ADDR_ALIGN` value for the device associated with the queue.
-   `"exec_status_error_for_events_in_wait_list"`: If the read and write operations are blocking and the execution status of any of the events in `event_wait_list` is a negative integer value.
-   `"mem_object_allocation_failure"`: There is a failure to allocate memory for data storage associated with the buffer.
-   `"invalid_operation"`: If `clEnqueueReadBuffer` is called on a buffer that has been created with `CL_MEM_HOST_WRITE_ONLY` or `CL_MEM_HOST_NO_ACCESS`.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Writing to a Buffer

### Description

The `write` function writes data from host memory to an OpenCL buffer object. This function allows for both blocking and non-blocking writes.

```zig
pub fn write(
    command_queue: cl_command_queue,
    buffer: cl_mem,
    blocking_write: bool,
    offset: usize,
    size: usize,
    ptr: *const anyopaque,
    event_wait_list: ?[]const cl_event,
    event: ?*cl_event
) errors.opencl_error!void;
```

### Parameters

-   **command_queue**: The `cl_command_queue` in which the write command will be queued.
-   **buffer**: Refers to a valid buffer object.
-   **blocking_write**: A boolean indicating if the write operation is blocking (`true`) or non-blocking (`false`).
-   **offset**: The offset in bytes in the buffer object to write to.
-   **size**: The size in bytes of data being written.
-   **ptr**: The pointer to buffer in host memory from where data is to be written.
-   **event_wait_list**: An optional list of events that need to complete before this particular command can be executed.
-   **event**: An optional event object that identifies this write command and can be used to query or queue a wait for this command to complete.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clEnqueueWriteBuffer` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_command_queue"`: The specified command queue is not valid.
-   `"invalid_context"`: The context associated with the command queue and buffer are not the same, or the context associated with command queue and events in `event_wait_list` are not the same.
-   `"invalid_mem_object"`: The specified buffer is not a valid buffer object.
-   `"invalid_value"`: The region being read or written specified by (offset, size) is out of bounds or if `ptr` is a NULL value.
-   `"invalid_event_wait_list"`: The `event_wait_list` is NULL and `num_events_in_wait_list` > 0, or `event_wait_list` is not NULL and `num_events_in_wait_list` is 0, or if event objects in `event_wait_list` are not valid events.
-   `"misaligned_sub_buffer_offset"`: The buffer is a sub-buffer object, and the offset specified when the sub-buffer object is created is not aligned to `CL_DEVICE_MEM_BASE_ADDR_ALIGN` value for the device associated with the queue.
-   `"exec_status_error_for_events_in_wait_list"`: If the read and write operations are blocking and the execution status of any of the events in `event_wait_list` is a negative integer value.
-   `"mem_object_allocation_failure"`: There is a failure to allocate memory for data storage associated with the buffer.
-   `"invalid_operation"`: If `clEnqueueWriteBuffer` is called on a buffer that has been created with `CL_MEM_HOST_READ_ONLY` or `CL_MEM_HOST_NO_ACCESS`.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Writing to a Rectangular Region of a Buffer

### Description

The `write_rect` function writes data from host memory to a rectangular region in an OpenCL buffer object. This function allows for both blocking and non-blocking writes.

```zig
pub fn write_rect(
    command_queue: cl_command_queue,
    buffer: cl_mem,
    blocking_write: bool,
    buffer_origin: []const usize,
    host_origin: []const usize,
    region: []const usize,
    buffer_row_pitch: usize,
    buffer_slice_pitch: usize,
    host_row_pitch: usize,
    host_slice_pitch: usize,
    ptr: *anyopaque,
    event_wait_list: ?[]const cl_event,
    event: ?*cl_event
) errors.opencl_error!void;
```

### Parameters

-   **command_queue**: The `cl_command_queue` in which the write command will be queued.
-   **buffer**: Refers to a valid buffer object.
-   **blocking_write**: A boolean indicating if the write operation is blocking (`true`) or non-blocking (`false`).
-   **buffer_origin**: Defines the (x, y, z) offset in the memory region associated with the buffer. For a 2D region, the z value should be 0.
-   **host_origin**: Defines the (x, y, z) offset in the memory region pointed to by `ptr`. For a 2D region, the z value should be 0.
-   **region**: Defines the (width in bytes, height in rows, depth in slices) of the 2D or 3D region being read or written. For a 2D rectangle copy, the depth value should be 1. The values cannot be 0.
-   **buffer_row_pitch**: The length of each row in bytes to be used for the memory region associated with the buffer. If 0, it is computed as `region[0]`.
-   **buffer_slice_pitch**: The length of each 2D slice in bytes to be used for the memory region associated with the buffer. If 0, it is computed as `region[1] * buffer_row_pitch`.
-   **host_row_pitch**: The length of each row in bytes to be used for the memory region pointed to by `ptr`. If 0, it is computed as `region[0]`.
-   **host_slice_pitch**: The length of each 2D slice in bytes to be used for the memory region pointed to by `ptr`. If 0, it is computed as `region[1] * host_row_pitch`.
-   **ptr**: The pointer to buffer in host memory where data is to be written from.
-   **event_wait_list**: An optional list of events that need to complete before this particular command can be executed.
-   **event**: An optional event object that identifies this write command and can be used to query or queue a wait for this command to complete.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clEnqueueWriteBufferRect` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_command_queue"`: The specified command queue is not valid.
-   `"invalid_context"`: The context associated with the command queue and buffer are not the same, or the context associated with command queue and events in `event_wait_list` are not the same.
-   `"invalid_mem_object"`: The specified buffer is not a valid buffer object.
-   `"invalid_value"`: The region being read or written specified by (buffer_origin, region, buffer_row_pitch, buffer_slice_pitch) is out of bounds. Any region array element is 0. The buffer row pitch is not 0 and is less than `region[0]`. The host row pitch is not 0 and is less than `region[0]`. The buffer slice pitch is not 0 and is less than `region[1] * buffer_row_pitch` and not a multiple of buffer row pitch. The host slice pitch is not 0 and is less than `region[1] * host_row_pitch` and not a multiple of host row pitch. If `ptr` is NULL.
-   `"invalid_event_wait_list"`: The `event_wait_list` is NULL and `num_events_in_wait_list` > 0, or `event_wait_list` is not NULL and `num_events_in_wait_list` is 0, or if event objects in `event_wait_list` are not valid events.
-   `"misaligned_sub_buffer_offset"`: The buffer is a sub-buffer object, and the offset specified when the sub-buffer object is created is not aligned to `CL_DEVICE_MEM_BASE_ADDR_ALIGN` value for the device associated with the queue.
-   `"exec_status_error_for_events_in_wait_list"`: If the read and write operations are blocking and the execution status of any of the events in `event_wait_list` is a negative integer value.
-   `"mem_object_allocation_failure"`: There is a failure to allocate memory for data storage associated with the buffer.
-   `"invalid_operation"`: If `clEnqueueWriteBufferRect` is called on a buffer that has been created with `CL_MEM_HOST_READ_ONLY` or `CL_MEM_HOST_NO_ACCESS`.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Reading from a Rectangular Region of a Buffer

### Description

The `read_rect` function reads data from a rectangular region in an OpenCL buffer object to host memory. This function allows for both blocking and non-blocking reads.

```zig
pub fn read_rect(
    command_queue: cl_command_queue,
    buffer: cl_mem,
    blocking_read: bool,
    buffer_origin: []const usize,
    host_origin: []const usize,
    region: []const usize,
    buffer_row_pitch: usize,
    buffer_slice_pitch: usize,
    host_row_pitch: usize,
    host_slice_pitch: usize,
    ptr: *anyopaque,
    event_wait_list: ?[]const cl_event,
    event: ?*cl_event
) errors.opencl_error!void;
```

### Parameters

-   **command_queue**: The `cl_command_queue` in which the read command will be queued.
-   **buffer**: Refers to a valid buffer object.
-   **blocking_read**: A boolean indicating if the read operation is blocking (`true`) or non-blocking (`false`).
-   **buffer_origin**: Defines the (x, y, z) offset in the memory region associated with the buffer. For a 2D region, the z value should be 0.
-   **host_origin**: Defines the (x, y, z) offset in the memory region pointed to by `ptr`. For a 2D region, the z value should be 0.
-   **region**: Defines the (width in bytes, height in rows, depth in slices) of the 2D or 3D region being read or written. For a 2D rectangle copy, the depth value should be 1. The values cannot be 0.
-   **buffer_row_pitch**: The length of each row in bytes to be used for the memory region associated with the buffer. If 0, it is computed as `region[0]`.
-   **buffer_slice_pitch**: The length of each 2D slice in bytes to be used for the memory region associated with the buffer. If 0, it is computed as `region[1] * buffer_row_pitch`.
-   **host_row_pitch**: The length of each row in bytes to be used for the memory region pointed to by `ptr`. If 0, it is computed as `region[0]`.
-   **host_slice_pitch**: The length of each 2D slice in bytes to be used for the memory region pointed to by `ptr`. If 0, it is computed as `region[1] * host_row_pitch`.
-   **ptr**: The pointer to buffer in host memory where data is to be read into.
-   **event_wait_list**: An optional list of events that need to complete before this particular command can be executed.
-   **event**: An optional event object that identifies this read command and can be used to query or queue a wait for this command to complete.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clEnqueueReadBufferRect` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_command_queue"`: The specified command queue is not valid.
-   `"invalid_context"`: The context associated with the command queue and buffer are not the same, or the context associated with command queue and events in `event_wait_list` are not the same.
-   `"invalid_mem_object"`: The specified buffer is not a valid buffer object.
-   `"invalid_value"`: The region being read or written specified by (buffer_origin, region, buffer_row_pitch, buffer_slice_pitch) is out of bounds. Any region array element is 0. The buffer row pitch is not 0 and is less than `region[0]`. The host row pitch is not 0 and is less than `region[0]`. The buffer slice pitch is not 0 and is less than `region[1] * buffer_row_pitch` and not a multiple of buffer row pitch. The host slice pitch is not 0 and is less than `region[1] * host_row_pitch` and not a multiple of host row pitch. If `ptr` is NULL.
-   `"invalid_event_wait_list"`: The `event_wait_list` is NULL and `num_events_in_wait_list` > 0, or `event_wait_list` is not NULL and `num_events_in_wait_list` is 0, or if event objects in `event_wait_list` are not valid events.
-   `"misaligned_sub_buffer_offset"`: The buffer is a sub-buffer object, and the offset specified when the sub-buffer object is created is not aligned to `CL_DEVICE_MEM_BASE_ADDR_ALIGN` value for the device associated with the queue.
-   `"exec_status_error_for_events_in_wait_list"`: If the read and write operations are blocking and the execution status of any of the events in `event_wait_list` is a negative integer value.
-   `"mem_object_allocation_failure"`: There is a failure to allocate memory for data storage associated with the buffer.
-   `"invalid_operation"`: If `clEnqueueReadBufferRect` is called on a buffer that has been created with `CL_MEM_HOST_WRITE_ONLY` or `CL_MEM_HOST_NO_ACCESS`.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Fill Buffer

### Description

The `fill` function fills a buffer with a specified pattern. This function is useful for initializing or resetting the contents of a buffer in OpenCL.

```zig
pub fn fill(
    command_queue: cl_command_queue,
    buffer: cl_mem,
    pattern: *const anyopaque,
    pattern_size: usize,
    offset: usize,
    size: usize,
    event_wait_list: ?[]const cl_event,
    event: ?*cl_event
) errors.opencl_error!void;
```

### Parameters

-   `command_queue`: The OpenCL command queue in which the fill command will be queued.
-   `buffer`: The valid buffer object to be filled.
-   `pattern`: Pointer to the data pattern of size `pattern_size` in bytes. The data pattern must be a scalar or vector integer or floating-point data type supported by OpenCL.
-   `pattern_size`: Size of the data pattern in bytes. It must be a power of two and less than or equal to the size of the largest supported data type.
-   `offset`: Location in bytes of the region to be filled. Must be a multiple of `pattern_size`.
-   `size`: Size in bytes of the region to be filled. Must be a multiple of `pattern_size`.
-   `event_wait_list`: List of events that need to complete before this particular command can be executed. If `NULL`, the function does not wait on any event to complete.
-   `event`: Returns an event object that identifies this command and can be used to query or queue a wait for this command to complete. If `NULL`, no event will be created.

### Error Handling

The function uses Zig's error handling to manage potential OpenCL errors. If the call to `clEnqueueFillBuffer` does not return `CL_SUCCESS`, an error is raised. Possible errors include:

-   `"invalid_command_queue"`: The specified command queue is not valid.
-   `"invalid_context"`: The context associated with the command queue and buffer are not the same.
-   `"invalid_mem_object"`: The specified buffer is not valid.
-   `"invalid_value"`: If the offset and size require accessing elements outside the buffer or if `pattern` is `NULL` or `pattern_size` is 0 or not a power of two.
-   `"invalid_event_wait_list"`: If the event wait list is `NULL` and the number of events in the wait list is greater than zero, or if the event objects are not valid events.
-   `"misaligned_sub_buffer_offset"`: If the buffer is a sub-buffer object and its offset is not aligned to `CL_DEVICE_MEM_BASE_ADDR_ALIGN`.
-   `"mem_object_allocation_failure"`: There is a failure to allocate memory for the data store associated with the buffer.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Copying Buffers

### Description

The `copy` function performs a buffer copy operation in OpenCL, copying data from a source buffer to a destination buffer within the same context. This function allows for specifying offsets, size, and events related to the copy operation.

```zig
pub fn copy(
	command_queue: cl_command_queue,
	src_buffer: cl_mem,
	dst_buffer: cl_mem,
	src_offset: usize,
	dst_offset: usize,
	size: usize,
	event_wait_list: ?[]const cl_event,
	event: ?*cl_event
) errors.opencl_error!void;
```

### Parameters

-   **command_queue**: The `cl_command_queue` in which the copy command will be queued. The OpenCL context associated with `command_queue`, `src_buffer`, and `dst_buffer` must be the same.
-   **src_buffer**: The source `cl_mem` buffer.
-   **dst_buffer**: The destination `cl_mem` buffer.
-   **src_offset**: The offset in bytes where to begin copying data from `src_buffer`.
-   **dst_offset**: The offset in bytes where to begin copying data into `dst_buffer`.
-   **size**: The size in bytes to copy.
-   **event_wait_list**: A pointer to an array of `cl_event` that need to complete before this command can be executed. If `event_wait_list` is null, no events need to complete before this command.
-   **event**: A pointer to a `cl_event` that will identify this copy command and can be used to query or queue a wait for this command to complete. If `event` is null, no event will be created.
    

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clEnqueueCopyBuffer` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_mem_object"`: The source or destination buffer is not a valid memory object.
-   `"invalid_value"`: The offset, size, or other parameter is invalid.
-   `"invalid_event_wait_list"`: The event wait list is invalid.
-   `"misaligned_sub_buffer_offset"`: A sub-buffer object is not aligned correctly.
-   `"mem_copy_overlap"`: The source and destination buffers overlap.
-   `"mem_object_allocation_failure"`: There is a failure to allocate memory for the buffer objects.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.
-   `"invalid_command_queue"`: The command queue is not valid.
-   `"invalid_context"`: The context associated with the command queue and buffer objects is not valid or not the same.

## Copying Rectangular Buffers

### Description

The `copy_rect` function performs a rectangular buffer copy operation in OpenCL, copying a 2D or 3D region of data from a source buffer to a destination buffer within the same context. This function allows for specifying offsets, region dimensions, and events related to the copy operation.

```zig
pub fn copy_rect(
    command_queue: cl_command_queue,
    src_buffer: cl_mem,
    dst_buffer: cl_mem,
    src_origin: []const usize,
    dst_origin: []const usize,
    region: []const usize,
    src_row_pitch: usize,
    src_slice_pitch: usize,
    dst_row_pitch: usize,
    dst_slice_pitch: usize,
    event_wait_list: ?[]const cl_event,
    event: ?*cl_event
) errors.opencl_error!void;
```

### Parameters

-   **command_queue**: The `cl_command_queue` in which the copy command will be queued. The OpenCL context associated with `command_queue`, `src_buffer`, and `dst_buffer` must be the same.
-   **src_buffer**: The source `cl_mem` buffer.
-   **dst_buffer**: The destination `cl_mem` buffer.
-   **src_origin**: The (x, y, z) offset in the memory region associated with `src_buffer`. For a 2D rectangle region, the z value should be 0. The offset in bytes is computed as `src_origin[2] * src_slice_pitch + src_origin[1] * src_row_pitch + src_origin[0]`.
-   **dst_origin**: The (x, y, z) offset in the memory region associated with `dst_buffer`. For a 2D rectangle region, the z value should be 0. The offset in bytes is computed as `dst_origin[2] * dst_slice_pitch + dst_origin[1] * dst_row_pitch + dst_origin[0]`.
-   **region**: The (width in bytes, height in rows, depth in slices) of the 2D or 3D region being copied. For a 2D rectangle, the depth value should be 1.
-   **src_row_pitch**: The length of each row in bytes to be used for the memory region associated with `src_buffer`. If `src_row_pitch` is 0, it is computed as `region[0]`.
-   **src_slice_pitch**: The length of each 2D slice in bytes to be used for the memory region associated with `src_buffer`. If `src_slice_pitch` is 0, it is computed as `region[1] * src_row_pitch`.
-   **dst_row_pitch**: The length of each row in bytes to be used for the memory region associated with `dst_buffer`. If `dst_row_pitch` is 0, it is computed as `region[0]`.
-   **dst_slice_pitch**: The length of each 2D slice in bytes to be used for the memory region associated with `dst_buffer`. If `dst_slice_pitch` is 0, it is computed as `region[1] * dst_row_pitch`.
-   **event_wait_list**: A pointer to an array of `cl_event` that need to complete before this command can be executed. If `event_wait_list` is null, no events need to complete before this command.
-   **event**: A pointer to a `cl_event` that will identify this copy command and can be used to query or queue a wait for this command to complete. If `event` is null, no event will be created.
    

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clEnqueueCopyBufferRect` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_command_queue"`: The command queue is not valid.
-   `"invalid_context"`: The context associated with the command queue and buffer objects is not valid or not the same.
-   `"invalid_mem_object"`: The source or destination buffer is not a valid memory object.
-   `"invalid_value"`: The offset, size, or other parameter is invalid.
-   `"invalid_event_wait_list"`: The event wait list is invalid.
-   `"misaligned_sub_buffer_offset"`: A sub-buffer object is not aligned correctly.
-   `"mem_copy_overlap"`: The source and destination buffers overlap.
-   `"mem_object_allocation_failure"`: There is a failure to allocate memory for the buffer objects.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Mapping Buffers

### Description

The `map` function maps a buffer into the host address space, allowing the application to read or write directly to the buffer. This function supports both blocking and non-blocking map operations and leverages Zig's `comptime` to provide a template-like mechanism for different pointer types.

```zig
pub fn map(
    comptime T: type,
    command_queue: cl_command_queue,
    buffer: cl_mem,
    blocking_map: bool,
    map_flags: cl_map_flags,
    offset: usize,
    size: usize,
    event_wait_list: ?[]const cl_event,
    event: ?*cl_event
) errors.opencl_error!T;
```

### Parameters

-   **T**: The type of the pointer to be returned. Must be a pointer type (e.g., `*T`, `[]T`, or `[*]T`).
-   **command_queue**: The `cl_command_queue` in which the map command will be queued. The OpenCL context associated with `command_queue` and `buffer` must be the same.
-   **buffer**: The `cl_mem` buffer to be mapped.
-   **blocking_map**: A boolean indicating if the map operation is blocking or non-blocking.
-   **map_flags**: A bit-field specifying the map operation. Values for constructing this bit-field can be obtained from the `buffer.enums.map_flags` enum. Possible values include:
    -   `CL_MAP_READ` -> `read`
    -   `CL_MAP_WRITE` -> `write`
-   **offset**: The offset in bytes in the buffer object to map.
-   **size**: The size in bytes of the region in the buffer object to map.
-   **event_wait_list**: A pointer to an array of `cl_event` that need to complete before this command can be executed. If `event_wait_list` is null, no events need to complete before this command.
-   **event**: A pointer to a `cl_event` that will identify this map command and can be used to query or queue a wait for this command to complete. If `event` is null, no event will be created.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clEnqueueMapBuffer` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_command_queue"`: The command queue is not valid.
-   `"invalid_context"`: The context associated with the command queue and buffer objects is not valid or not the same.
-   `"invalid_mem_object"`: The buffer is not a valid memory object.
-   `"invalid_value"`: The offset, size, or map flags are invalid.
-   `"invalid_event_wait_list"`: The event wait list is invalid.
-   `"misaligned_sub_buffer_offset"`: A sub-buffer object is not aligned correctly.
-   `"mem_copy_overlap"`: The source and destination buffers overlap.
-   `"mem_object_allocation_failure"`: There is a failure to allocate memory for the buffer objects.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.
-   `"invalid_operation"`: The map operation is invalid due to overlapping regions being mapped for writing or due to the buffer being created with certain flags.

## Unmapping Buffers

### Description

The `unmap` function unmaps a previously mapped buffer from the host address space. This function completes any operations on the mapped region and makes the buffer available for other operations in OpenCL. This function leverages Zig's `comptime` to provide a template-like mechanism for different pointer types.

```zig
pub fn unmap(
    comptime T: type,
    command_queue: cl_command_queue,
    buffer: cl_mem,
    mapped_ptr: T,
    event_wait_list: ?[]const cl_event,
    event: ?*cl_event
) errors.opencl_error!void;
```

### Parameters

-   **T**: The type of the pointer to be unmapped. Must be a pointer type (e.g., `*T`, `[]T`, or `[*]T`).
-   **command_queue**: The `cl_command_queue` in which the unmap command will be queued. The OpenCL context associated with `command_queue` and `buffer` must be the same.
-   **buffer**: The `cl_mem` buffer to be unmapped.
-   **mapped_ptr**: The pointer to the mapped region in the host address space.
-   **event_wait_list**: A pointer to an array of `cl_event` that need to complete before this command can be executed. If `event_wait_list` is null, no events need to complete before this command.
-   **event**: A pointer to a `cl_event` that will identify this unmap command and can be used to query or queue a wait for this command to complete. If `event` is null, no event will be created.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clEnqueueUnmapMemObject` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_command_queue"`: The command queue is not valid.
-   `"invalid_mem_object"`: The buffer is not a valid memory object.
-   `"invalid_value"`: The mapped pointer is not a valid pointer returned by `clEnqueueMapBuffer` or `clEnqueueMapImage`.
-   `"invalid_event_wait_list"`: The event wait list is invalid.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.
-   `"invalid_context"`: The context associated with the command queue and buffer objects is not valid or not the same.

## Retaining a Memory Object

### Description

The `retain` function increments the reference count of a memory object. This function is used to ensure that the memory object remains valid even if other references to it are released.

```zig
pub fn retain(buffer: cl_mem) errors.opencl_error!void;
```

### Parameters

-   **buffer**: The `cl_mem` memory object to be retained.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clRetainMemObject` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_mem_object"`: The buffer is not a valid memory object.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Releasing a Memory Object

### Description

The `release` function decrements the reference count of a memory object. When the reference count becomes zero, the memory object is deleted. This function ensures that resources are properly released when they are no longer needed.

```zig
pub fn release(buffer: cl_mem) errors.opencl_error!void; 
```

### Parameters

-   **buffer**: The `cl_mem` memory object to be released.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clReleaseMemObject` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_mem_object"`: The buffer is not a valid memory object.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

