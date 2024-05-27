# Buffer

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

