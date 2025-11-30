## Creating a Kernel

### Description

The `create` function creates a kernel object for a specific function declared in a program. This function ensures that the kernel is properly set up and ready to be used in OpenCL operations.

```zig
pub fn create(program: Program, kernel_name: []const u8) OpenCLError!Kernel;
```

### Parameters

-   **program**: The `Program` object with a successfully built executable.
-   **kernel_name**: The name of the kernel function declared with the `__kernel` qualifier in the program.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clCreateKernel` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `InvalidProgram`: The program is not a valid program object.
-   `InvalidProgramExecutable`: There is no successfully built executable for the program.
-   `InvalidKernelName`: The kernel name is not found in the program.
-   `InvalidKernelDefinition`: The function definition for the `__kernel` function given by kernel_name does not match for all devices for which the program executable has been built.
-   `InvalidValue`: The kernel_name is null.
-   `OutOfResources`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `OutOfHostMemory`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Setting a Kernel Argument

### Description

The `set_arg` function sets the value of a specific argument for a kernel object. This function ensures that the kernel's argument is properly configured for execution.

```zig
pub fn setArg(
    kernel: Kernel,
    arg_index: u32,
    arg_size: usize,
    arg_value: ?*const anyopaque,
) OpenCLError!void;
```

### Parameters

-   **kernel**: A valid `Kernel` object.
-   **arg_index**: The argument index. Arguments to the kernel are referred to by indices that go from 0 for the leftmost argument to `n - 1`, where `n` is the total number of arguments declared by the kernel.
-   **arg_size**: Specifies the size of the argument value. If the argument is a memory object, the `arg_size` value must be equal to `sizeof(cl_mem)`. For arguments declared with the `local` qualifier, the size specified will be the size in bytes of the buffer that must be allocated for the `local` argument. If the argument is of type `sampler_t`, the `arg_size` value must be equal to `sizeof(cl_sampler)`. If the argument is of type `queue_t`, the `arg_size` value must be equal to `sizeof(cl_command_queue)`. For all other arguments, the size will be the size of the argument type.
-   **arg_value**: A pointer to data that should be used as the argument value for the argument specified by `arg_index`. The argument data pointed to by `arg_value` is copied and the `arg_value` pointer can therefore be reused by the application after `clSetKernelArg` returns. The argument value specified is the value used by all API calls that enqueue `kernel` (`clEnqueueNDRangeKernel` and `clEnqueueTask`) until the argument value is changed by a call to `clSetKernelArg` for `kernel`.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clSetKernelArg` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `InvalidKernel`: The kernel is not a valid kernel object.
-   `InvalidArgIndex`: The arg_index is not a valid argument index.
-   `InvalidArgValue`: The arg_value specified is not a valid value.
-   `InvalidMemObject`: For an argument declared to be a memory object, the arg_value is not a valid memory object.
-   `InvalidSampler`: For an argument declared to be of type sampler_t, the arg_value is not a valid sampler object.
-   `InvalidDeviceQueue`: For an argument declared to be of type queue_t, the arg_value is not a valid device queue object.
-   `InvalidArgSize`: The arg_size does not match the size of the data type for an argument that is not a memory object or if the argument is a memory object and arg_size is not equal to `sizeof(cl_mem)` or if arg_size is zero and the argument is declared with the `local` qualifier or if the argument is a sampler and arg_size is not equal to `sizeof(cl_sampler)`.
-   `MaxSizeRestrictionExceeded`: The size in bytes of the memory object exceeds a language-specified maximum size restriction for this argument, such as the `MaxByteOffset` SPIR-V decoration.
-   `OutOfResources`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `OutOfHostMemory`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Enqueueing ND Range

### Description

The `enqueue_nd_range` function enqueues a command to execute a kernel on a device. This function allows the application to specify the dimensions and size of the global and local work-items, as well as any events to wait for and generate.

```zig
pub fn enqueueNdRange(
    command_queue: CommandQueue,
    kernel: Kernel,
    global_work_offset: ?[]const usize,
    global_work_size: []const usize,
    local_work_size: ?[]const usize,
    event_wait_list: ?[]const Event,
    event: ?*Event,
) OpenCLError!void;
```

### Parameters

-   `command_queue`: The `CommandQueue` in which the kernel will be queued for execution.
-   `kernel`: The `Kernel` object. The OpenCL context associated with `kernel` and `command_queue` must be the same.
-   `global_work_offset`: An optional array of offsets to calculate the global ID of a work-item. If `global_work_offset` is null, the global IDs start at offset (0, 0, 0).
-   `global_work_size`: An array of dimensions describing the number of global work-items. The number of global work-items is computed as `global_work_size[0] * ... * global_work_size[work_dim - 1]`.
-   `local_work_size`: An optional array of dimensions describing the number of work-items that make up a work-group. The total number of work-items in the work-group is computed as `local_work_size[0] * ... * local_work_size[work_dim - 1]`.
-   `event_wait_list`: An optional array of events that need to complete before this command can be executed. If `event_wait_list` is null, the command does not wait on any event.
-   `event`: A pointer to an `Event` object that identifies this command. If `event` is null, no event will be created.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clEnqueueNDRangeKernel` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `InvalidProgramExecutable`: No successfully built program executable available.
-   `InvalidCommandQueue`: Invalid host command-queue.
-   `InvalidKernel`: Invalid kernel object.
-   `InvalidContext`: Context associated with `command_queue` and `kernel` are not the same.
-   `InvalidKernelArgs`: Kernel argument values not specified.
-   `InvalidWorkDimension`: Invalid work dimension.
-   `InvalidGlobalWorkSize`: Global work size is null or has an invalid value.
-   `InvalidGlobalOffset`: Global offset is invalid.
-   `InvalidWorkGroupSize`: Local work size is invalid or not consistent.
-   `InvalidWorkItemSize`: Number of work-items specified in any dimension is greater than the corresponding value specified by `CL_DEVICE_MAX_WORK_ITEM_SIZES`.
-   `MisalignedSubBufferOffset`: Offset specified is not aligned.
-   `InvalidImageSize`: Image size specified is not supported.
-   `ImageFormatNotSupported`: Image format specified is not supported.
-   `OutOfResources`: Insufficient resources to execute the kernel.
-   `MemObjectAllocationFailure`: Failure to allocate memory.
-   `InvalidEventWaitList`: Event wait list is invalid.
-   `InvalidOperation`: Invalid operation.
-   `OutOfHostMemory`: Failure to allocate resources on the host.

## Retaining a Kernel

### Description

The `retain` function increments the reference count of a kernel object. This function ensures that the kernel object is not released while it is still being used.

```zig
pub fn retain(kernel: Kernel) OpenCLError!void;
```

### Parameters

-   `kernel`: The `Kernel` object to be retained. The kernel reference count is incremented.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clRetainKernel` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `InvalidKernel`: The kernel object is not valid.
-   `OutOfResources`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `OutOfHostMemory`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Releasing a Kernel

### Description

The `release` function decrements the reference count of a kernel object. When the reference count becomes zero, the kernel object is deleted.

```zig
pub fn release(kernel: Kernel) void;
```

### Parameters

-   `kernel`: The `Kernel` object to be released. The kernel reference count is decremented.
