## Creating a Program with Source

### Description

The `create_with_source` function creates a program object for a context, and loads the source code specified by strings into the program object. This function manages the memory allocation for the source strings using the provided allocator.

```zig
pub inline fn createWithSource(
    context: Context,
    strings: []const []const u8,
    allocator: std.mem.Allocator,
) !Program;
```

### Parameters

-   **context**: The `Context` in which the program will be created. Must be a valid OpenCL context.
-   **strings**: An array of pointers to optionally null-terminated character strings that make up the source code.
-   **allocator**: The allocator used for managing the memory of the source strings.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clCreateProgramWithSource` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `InvalidContext`: The context is not a valid context.
-   `InvalidValue`: The count is zero or any entry in strings is null.
-   `OutOfResources`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `OutOfHostMemory`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Compiling a Program

### Description

The `compile` function compiles a program from source or binary using the specified devices. It allows specifying build options, input headers, and additional parameters for the compilation process. This function handles memory management for header includes and options using the provided allocator.

```zig
pub inline fn compile(
    allocator: std.mem.Allocator,
    program: Program,
    devices: ?[]const DeviceId,
    options: ?[]const u8,
    input_headers: ?[]const Program,
    header_include_names: ?[]const []const u8,
    callback: ?*const Callback,
    user_data: ?*anyopaque,
) !void;
```

### Parameters

-   **allocator**: The allocator used for managing the memory of options and headers.
-   **program**: The `Program` object to be compiled.
-   **devices**: A list of `DeviceId` for which the program executable will be compiled. If `devices` is null, the program is compiled for all devices associated with the program.
-   **options**: A pointer to a null-terminated string that describes the compilation options. If `options` is null, the program is compiled with no additional options.
-   **input_headers**: An array of program objects that are considered as input headers. If `input_headers` is null, no input headers are used.
-   **header_include_names**: An array of strings corresponding to the header names. If `header_include_names` is null, no headers are included.
-   **callback**: A function pointer to a notification routine called upon completion of the compilation process.
-   **user_data**: A pointer to user data passed to the callback function. Can be null if `callback` is not null.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If `clCompileProgram` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `InvalidProgram`: The program is not a valid program object.
-   `InvalidValue`: Invalid values for devices, options, or headers.
-   `InvalidDevice`: The device in the device list is not valid.
-   `InvalidOperation`: An invalid operation occurred during compilation.
-   `InvalidCompilerOptions`: The compiler options are invalid.
-   `CompilerNotAvailable`: No compiler is available.
-   `CompileProgramFailure`: Failure to compile the program.
-   `OutOfResources`: Failure to allocate resources required by the OpenCL implementation on the device.
-   `OutOfHostMemory`: Failure to allocate resources required by the OpenCL implementation on the host.

## Linking a Program

### Description

The `link` function links a set of compiled program objects into a single program executable. This function allows specifying devices, input programs, and linker options. It also supports an optional callback function that is invoked when the linking operation is complete.

```zig
pub inline fn link(
    context: Context,
    devices: []const DeviceId,
    options: ?[]const u8,
    input_programs: []const Program,
    callback: ?*const Callback,
    user_data: ?*anyopaque,
) OpenCLError!Program;
```

### Parameters

-   **context**: The OpenCL context in which the linking operation will be performed.
-   **devices**: A list of `DeviceId` that specifies the devices for which the program executable will be linked.
-   **options**: A pointer to a null-terminated string specifying linker options. If `options` is null, no additional linker options are used.
-   **input_programs**: An array of program objects that contain the compiled binaries to be linked.
-   **callback**: A function pointer to a notification routine that is called when the program linking is complete.
-   **user_data**: A pointer to user data passed to the callback function. Can be null if `callback` is not null.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If `clLinkProgram` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `InvalidContext`: The context is not a valid OpenCL context.
-   `InvalidValue`: Invalid values for devices, input programs, or options.
-   `InvalidProgram`: One or more of the input programs are not valid.
-   `InvalidDevice`: The device in the device list is not valid.
-   `InvalidLinkerOptions`: The linker options are invalid.
-   `InvalidOperation`: An invalid operation occurred during linking.
-   `LinkerNotAvailable`: The OpenCL linker is not available.
-   `LinkProgramFailure`: Failure to link the program.
-   `OutOfResources`: Failure to allocate resources required by the OpenCL implementation on the device.
-   `OutOfHostMemory`: Failure to allocate resources required by the OpenCL implementation on the host.

## Building a Program

### Description

The `build` function compiles and links a program executable from the program source or binary for the devices associated with the program. This function also allows specifying build options and a callback function for notification upon completion.

```zig
pub inline fn build(
    program: Program,
    device_list: []const DeviceId,
    options: ?[]const u8,
    callback: ?*const Callback,
    user_data: ?*anyopaque,
) OpenCLError!void;
```

### Parameters

-   **program**: The `Program` object to be built.
-   **device_list**: A list of `DeviceId` for which the program executable will be built. If `device_list` is null, the program is built for all devices associated with the program.
-   **options**: A pointer to a null-terminated string that describes the build options to be used. If `options` is null, the program is built with no additional options.
-   **callback**: A function pointer to a notification routine that is called when the program executable has been built (successfully or unsuccessfully). If `callback` is null, the function does not return until the build operation is complete.
-   **user_data**: A pointer to user data that will be passed to the callback function. Can be null if `callback` is null.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clBuildProgram` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `InvalidProgram`: The program is not a valid program object.
-   `InvalidValue`: Invalid values for device list or options.
-   `InvalidDevice`: The device in the device list is not valid.
-   `InvalidBinary`: The program created with `clCreateProgramWithBinary` does not have a valid program binary.
-   `InvalidBuildOptions`: The build options are invalid.
-   `CompilerNotAvailable`: No compiler is available.
-   `BuildProgramFailure`: Failure to build the program executable.
-   `InvalidOperation`: Invalid operations due to kernel objects or previous builds.
-   `OutOfResources`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `OutOfHostMemory`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Getting Program Build Information

### Description

The `get_build_info` function queries information about the build of a program object for a specific device. This function retrieves various types of information specified by `param_name`.

```zig
pub inline fn get_build_info(
    program: Program,
    device: DeviceId,
    param_name: BuildInfo,
    param_value_size: usize,
    param_value: ?*anyopaque,
    param_value_size_ret: ?*usize,
) OpenCLError!void;
```

### Parameters

-   **program**: The `Program` object being queried.
-   **device**: The `DeviceId` for which build information is being queried. Must be a valid device associated with the program.
-   **param_name**: An enumeration constant that specifies the information to query. This is a member of the `BuildInfo` enum, which contains various build information types.
-   **param_value_size**: The size in bytes of memory pointed to by `param_value`.
-   **param_value**: A pointer to memory where the appropriate result being queried is returned. If `param_value` is null, it is ignored.
-   **param_value_size_ret**: A pointer to a value that returns the actual size in bytes of data being queried by `param_name`. If `param_value_size_ret` is null, it is ignored.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clGetProgramBuildInfo` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `InvalidDevice`: The device is not in the list of devices associated with the program.
-   `InvalidValue`: The `param_name` is not valid, or the size specified by `param_value_size` is less than the size of the return type.
-   `InvalidProgram`: The program is not a valid program object.
-   `OutOfResources`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `OutOfHostMemory`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Retaining a Program

### Description

The `retain` function increments the reference count of a program object. This function ensures that the program object remains valid even if other references to it are released.

```zig
pub inline fn retain(program: Program) OpenCLError!void;
```

### Parameters

-   **program**: The `Program` object to be retained.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clRetainProgram` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `InvalidProgram`: The program is not a valid program object.
-   `OutOfResources`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `OutOfHostMemory`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Releasing a Program

### Description

The `release` function decrements the reference count of a program object. When the reference count becomes zero, the program object is deleted. This function ensures that resources are properly released when they are no longer needed.

```zig
pub inline fn release(program: Program) void;
```

### Parameters

-   **program**: The `Program` object to be released.
