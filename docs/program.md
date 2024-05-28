## Creating a Program with Source

### Description

The `create_with_source` function creates a program object for a context, and loads the source code specified by strings into the program object. This function manages the memory allocation for the source strings using the provided allocator.

```zig
pub fn create_with_source(
    context: cl_context,
    strings: []const []const u8,
    allocator: std.mem.Allocator
) !cl_program;
```

### Parameters

-   **context**: The `cl_context` in which the program will be created. Must be a valid OpenCL context.
-   **strings**: An array of pointers to optionally null-terminated character strings that make up the source code.
-   **allocator**: The allocator used for managing the memory of the source strings.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clCreateProgramWithSource` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_context"`: The context is not a valid context.
-   `"invalid_value"`: The count is zero or any entry in strings is null.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Building a Program

### Description

The `build` function compiles and links a program executable from the program source or binary for the devices associated with the program. This function also allows specifying build options and a callback function for notification upon completion.

```zig
pub fn build(
    program: cl_program,
    device_list: []const cl_device_id,
    options: ?[]const u8,
    callback: ?*const pfn_notify_callback,
    user_data: ?*anyopaque
) errors.opencl_error!void;
```

### Parameters

-   **program**: The `cl_program` object to be built.
-   **device_list**: A list of `cl_device_id` for which the program executable will be built. If `device_list` is null, the program is built for all devices associated with the program.
-   **options**: A pointer to a null-terminated string that describes the build options to be used. If `options` is null, the program is built with no additional options.
-   **callback**: A function pointer to a notification routine that is called when the program executable has been built (successfully or unsuccessfully). If `callback` is null, the function does not return until the build operation is complete.
-   **user_data**: A pointer to user data that will be passed to the callback function. Can be null if `callback` is null.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clBuildProgram` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_program"`: The program is not a valid program object.
-   `"invalid_value"`: Invalid values for device list or options.
-   `"invalid_device"`: The device in the device list is not valid.
-   `"invalid_binary"`: The program created with `clCreateProgramWithBinary` does not have a valid program binary.
-   `"invalid_build_options"`: The build options are invalid.
-   `"compiler_not_available"`: No compiler is available.
-   `"build_program_failure"`: Failure to build the program executable.
-   `"invalid_operation"`: Invalid operations due to kernel objects or previous builds.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Getting Program Build Information

### Description

The `get_build_info` function queries information about the build of a program object for a specific device. This function retrieves various types of information specified by `param_name`.

```zig
pub fn get_build_info(
    program: cl_program,
    device: cl_device_id,
    param_name: enums.build_info,
    param_value_size: usize,
    param_value: ?*anyopaque,
    param_value_size_ret: ?*usize
) errors.opencl_error!void;
```

### Parameters

-   **program**: The `cl_program` object being queried.
-   **device**: The `cl_device_id` for which build information is being queried. Must be a valid device associated with the program.
-   **param_name**: An enumeration constant that specifies the information to query. This is a member of the `program.enums.build_info` enum, which contains various build information types.
-   **param_value_size**: The size in bytes of memory pointed to by `param_value`.
-   **param_value**: A pointer to memory where the appropriate result being queried is returned. If `param_value` is null, it is ignored.
-   **param_value_size_ret**: A pointer to a value that returns the actual size in bytes of data being queried by `param_name`. If `param_value_size_ret` is null, it is ignored.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clGetProgramBuildInfo` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_device"`: The device is not in the list of devices associated with the program.
-   `"invalid_value"`: The `param_name` is not valid, or the size specified by `param_value_size` is less than the size of the return type.
-   `"invalid_program"`: The program is not a valid program object.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Retaining a Program

### Description

The `retain` function increments the reference count of a program object. This function ensures that the program object remains valid even if other references to it are released.

```zig
pub fn retain(program: cl_program) errors.opencl_error!void;
```

### Parameters

-   **program**: The `cl_program` object to be retained.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clRetainProgram` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_program"`: The program is not a valid program object.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Releasing a Program

### Description

The `release` function decrements the reference count of a program object. When the reference count becomes zero, the program object is deleted. This function ensures that resources are properly released when they are no longer needed.

```zig
pub fn release(program: cl_program) errors.opencl_error!void;
```

### Parameters

-   **program**: The `cl_program` object to be released.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clReleaseProgram` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_program"`: The program is not a valid program object.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

