# Platform

## Querying Platform Info

### Description
The `get_ids` function queries the list of available OpenCL platforms and returns the number of platforms and their IDs. This is a crucial step in setting up an OpenCL context, as it allows the application to identify and select a specific platform to use.
```zig
pub fn get_ids(platforms: ?[]cl_platform_id, num_platforms: ?*u32) errors.opencl_error!void;
```
#### Parameters

-   `platforms`: A pointer to an array of `cl_platform_id` where the function will store the IDs of the available OpenCL platforms. If `platforms` is `null`, the function will not store the platform IDs, but it will still return the number of available platforms through `num_platforms`.
-   `num_platforms`: A pointer to a `u32` variable where the function will store the number of available OpenCL platforms. If `num_platforms` is `null`, this argument is ignored.

#### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clGetPlatformIDs` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_value"`: The function was called with invalid parameters.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Querying Platform Info

### Description

The `get_info` function retrieves specific information about an OpenCL platform. This function is essential for obtaining various details about the platform, such as its name, profile, version, and other attributes.
```zig
pub fn get_info(
    platform: cl_platform_id, 
    param_name: enums.platform_info, 
    param_value_size: usize, 
    param_value: ?*anyopaque, 
    param_value_size_ret: ?*usize
) errors.opencl_error!void;
```
#### Parameters

-   `platform`: The `cl_platform_id` for which the information is being queried.
-   `param_name`: An enumeration constant that identifies the platform information being queried. This is a member of the `platform.enums.platform_info` namespace, which contains various attributes related to the platform. For example:
    -   `CL_PLATFORM_PROFILE` -> `profile`
    -   `CL_PLATFORM_NAME` -> `name`
-   `param_value_size`: Specifies the size in bytes of memory pointed to by `param_value`.
-   `param_value`: A pointer to the memory location where the appropriate values for the given `param_name` will be returned. If `param_value` is `null`, it is ignored.
-   `param_value_size_ret`: Returns the actual size in bytes of data being queried by `param_name`. If `param_value_size_ret` is `null`, it is ignored.

For a full list of the enum members, refer to the OpenCL PDF documentation or the `src/enums/platform.zig` file where the enums are defined.

#### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clGetPlatformInfo` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_value"`: The function was called with invalid parameters.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.
-   `"invalid_platform"`: The specified platform is not valid.

## Getting All Platforms

### Description

The `get_all` function retrieves a list of all available OpenCL platforms and their associated data. This function simplifies the process of obtaining detailed information about each platform.
```zig
pub fn get_all(allocator: std.mem.Allocator) ![]platform_info;
```
#### Parameters

-   `allocator`: An instance of `std.mem.Allocator` used to allocate memory for the platform information structures.

#### Return Value
-   Returns a slice of `platform_info` structures, each containing detailed information about an OpenCL platform, including its `id`, `profile`, `version`, `name`, `vendor`, and `extensions`.

## Releasing Platform List

### Description

The `release_list` function releases the memory allocated for the list of platform information structures.
```zig
pub fn release_list(allocator: std.mem.Allocator, platform_infos: []platform_info) void;
```
#### Parameters

-   `allocator`: An instance of `std.mem.Allocator` used to deallocate memory for the platform information structures.
-   `platform_infos`: A slice of `platform_info` structures that were previously allocated by the `get_all` function.

#### Example Usage

To retrieve and release the list of all platforms:
```zig
const cl = @import("opencl");
// ...

const allocator = std.heap.page_allocator;

const platform_infos = try cl.platform.get_all(allocator);
defer release_list(allocator, platform_infos);
// Use the platform_infos as needed
```
