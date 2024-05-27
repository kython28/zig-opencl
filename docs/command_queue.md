# Command queue

## Create a command queue

Creates a command queue on a specific device within a context. Command queues are used to schedule the execution of kernels and the transfer of data.
```zig
pub fn create(
    context: cl_context, 
    device: cl_device_id, 
    properties: cl_command_queue_properties
) errors.opencl_error!cl_command_queue;
```

**Parameters**
-   `context`: Must be a valid OpenCL context.
-   `device`: Must be a device or sub-device associated with `context`. It can either be in the list of devices and sub-devices specified when `context` is created using `clCreateContext` or be a root device with the same device type as specified when `context` is created using `clCreateContextFromType`.
-  `properties`: An optional list of context properties and their values. To use this, please go to the `command_queue.enums.queue_properties` enum and read the OpenCL PDF documentation about to use it.

**Error Handling**

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clCreateCommandQueue` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_value"`: Values specified in properties are not valid.
-   `"invalid_context"`: If context is not a valid context.
-   `"invalid_device"`: If device is not a valid device or is not associated with context.
-   `"invalid_queue_properties"`: If values specified in properties are valid but are not supported by the device.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Create a command queue with properties

The `create_with_properties` function creates a command queue with specified properties.

```zig
pub fn create_with_properties(
    context: cl_context, 
    device: cl_device_id, 
    properties: ?[]const cl_queue_properties
) errors.opencl_error!cl_command_queue
```

#### Parameters

-   `context`: Specifies the OpenCL context. It must be a valid OpenCL context.
-   `device`: Specifies the device or sub-device associated with the context. It must be a valid device or sub-device.
-   `properties`: Specifies a list of properties for the command queue and their corresponding values. Each property name is immediately followed by the corresponding desired value. This list is terminated with 0. If a supported property and its value is not specified in `properties`, its default value will be used. If `properties` is `null`, default values for supported command-queue properties will be used. (To get the properties name you can use: `command_queue.enums.command_queue_properties`)

#### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clCreateCommandQueueWithProperties` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_value"`: Values specified in properties are not valid.
-   `"invalid_context"`: Context is not a valid context.
-   `"invalid_device"`: Device is not a valid device or is not associated with context.
-   `"invalid_queue_properties"`: Values specified in properties are valid but are not supported by the device.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Flush a Command Queue

The `flush` function issues all previously queued OpenCL commands in `command_queue` to the device associated with `command_queue`.

```zig
pub fn flush(command_queue: cl_command_queue) errors.opencl_error!void;
```

#### Parameters

-   `command_queue`: The command-queue to flush.

#### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clFlush` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_command_queue"`: If `command_queue` is not a valid host command-queue.
-   `"out_of_resources"`: If there is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: If there is a failure to allocate resources required by the OpenCL implementation on the host.

## Waiting for Command Queue to Finish

### Description

The `finish` function ensures that all previously queued OpenCL commands in a command queue have been issued to the associated device and that all these commands have completed execution. This function blocks until the execution of all previously queued commands in the specified command queue is complete.

```zig
pub fn finish(command_queue: cl_command_queue) errors.opencl_error!void;
```

#### Parameters

-   **command_queue**: The `cl_command_queue` for which the function waits for the completion of all previously queued commands.

#### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clFinish` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.
-   `"invalid_command_queue"`: The specified command queue is not valid.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.

## Retaining a Command Queue

### Description

The `retain` function increments the reference count of the specified command queue. This ensures that the command queue is not deleted while it is still in use.

```zig
pub fn retain(command_queue: cl_command_queue) errors.opencl_error!void;
```

### Parameters

-   **command_queue**: The `cl_command_queue` whose reference count is to be incremented.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clRetainCommandQueue` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.
-   `"invalid_command_queue"`: The specified command queue is not valid.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.

## Releasing a Command Queue

### Description

The `release` function decrements the reference count of the specified command queue. When the reference count reaches zero, the command queue is deleted.

```zig
pub fn release(command_queue: cl_command_queue) errors.opencl_error!void;
```

### Parameters

-   **command_queue**: The `cl_command_queue` whose reference count is to be decremented.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clReleaseCommandQueue` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.
-   `"invalid_command_queue"`: The specified command queue is not valid.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.

