## Create a context

### Description

The `create` function creates an OpenCL context, which is used by the OpenCL runtime to manage objects such as command-queues, memory, programs, and kernels.

```zig
pub inline fn create(
    properties: ?[]const cl_context_properties, 
    devices: []const cl_device_id, 
    pfn_notify: ?*const pfn_notify_callback, 
    user_data: ?*anyopaque
) errors.opencl_error!cl_context;
```

#### Parameters

-   `properties`: An optional list of context properties and their values. To use this, please go to the `context.enums.context_properties` enum and read the OpenCL PDF documentation about to use it.
-   `devices`: A list of `device.cl_device_id` specifying the devices to be associated with the context.
-   `pfn_notify`: A callback function that can be registered by the application. It will be called when there is a context error.
-   `user_data`: A pointer to user-supplied data that will be passed to the callback function.

#### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clCreateContext` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_value"`: The devices list is `null`, the num_devices is zero, or pfn_notify is `null` but user_data is not `null`.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.
-   `"invalid_platform"`: The specified platform is not valid or not specified.
-   `"device_not_available"`: A device in the devices list is currently not available.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"invalid_property"`: The value for a supported property name is not valid, or if the same property name is specified more than once.
-   `"invalid_device"`: Any device in the devices list is not a valid device.

## Creating Context from Type

```zig
pub inline fn create_from_type(
    properties: ?[]const cl_context_properties,
    device_type: device.enums.device_type,
    pfn_notify: ?*const pfn_notify_callback,
    user_data: ?*anyopaque
) errors.opencl_error!cl_context;
```

#### Parameters

-   `properties`: A list of context property names and their corresponding values. Each property name is immediately followed by the corresponding desired value. The list of supported properties, and their default values if not present in `properties`, is described in the Context Properties table. `properties` can be `null`, in which case all properties take on their default values.
    
-   `device_type`: A bit-field that identifies the type of device and is described in the Device Types table. This is a member of the enum `device.enums.device_type`. For example:
    -   `CL_DEVICE_TYPE_CPU` -> `cpu`
    -   `CL_DEVICE_TYPE_GPU` -> `gpu`
-   `pfn_notify`: A callback function that can be registered by the application. This callback function will be used by the OpenCL implementation to report errors that occur during context creation as well as errors that occur at runtime in this context. This callback function may be called asynchronously by the OpenCL implementation. It is the application's responsibility to ensure that the callback function is thread-safe. If `pfn_notify` is `null`, no callback function is registered.
    
-   `user_data`: Will be passed as the `user_data` argument when `pfn_notify` is called. `user_data` can be `null`.
    

For a full list of the enum members, refer to the OpenCL PDF documentation or the `src/enums/device.zig` file where the enums are defined.

#### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clCreateContextFromType` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_platform"`: No platform is specified in properties and no platform could be selected, or if the platform specified in properties is not a valid platform.
-   `"invalid_property"`: A context property name in properties is not a supported property name, if the value specified for a supported property name is not valid, or if the same property name is specified more than once.
-   `"invalid_value"`: If `pfn_notify` is `null` but `user_data` is not `null`.
-   `"invalid_device_type"`: If `device_type` is not a valid value.
-   `"device_not_available"`: If no devices that match `device_type` and property values specified in properties are currently available.
-   `"device_not_found"`: If no devices that match `device_type` and property values specified in properties were found.
-   `"out_of_resources"`: If there is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: If there is a failure to allocate resources required by the OpenCL implementation on the host.

## Getting Context Information

### Description
The `get_info` function is used to query various types of information about an OpenCL context, such as the reference count, number of devices, and other attributes.

```zig
pub inline fn get_info(
    context: cl_context,
    param_name: enums.context_info,
    param_value_size: usize,
    param_value: ?*anyopaque,
    param_value_size_ret: ?*usize
) errors.opencl_error!void;
```

#### Parameters

-   `context`: Specifies the OpenCL context being queried.
-   `param_name`: Specifies the information to query. This is a member of the `context.enums.context_info` enum. For example:
    -   `CL_CONTEXT_REFERENCE_COUNT` -> `reference_count`
    -   `CL_CONTEXT_NUM_DEVICES` -> `num_devices`
-   `param_value_size`: Specifies the size in bytes of memory pointed to by `param_value`. This size must be greater than or equal to the size of the return type as described in the Context Attributes table.
-   `param_value`: A pointer to memory where the appropriate result being queried is returned. If `param_value` is `null`, it is ignored.
-   `param_value_size_ret`: Returns the actual size in bytes of data being queried by `param_name`. If `param_value_size_ret` is `null`, it is ignored.

For a full list of the enum members, refer to the OpenCL PDF documentation or the `src/enums/context.zig` file where the enums are defined.

#### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clGetContextInfo` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_value"`: The function was called with invalid parameters.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.
-   `"invalid_context"`: The specified context is not valid.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.

### Retain a context

```zig
pub inline fn retain(context: cl_context) errors.opencl_error!void;
``` 

#### Parameters

-   `context`: Specifies the OpenCL context to retain.

#### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clRetainContext` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_context"`: If the specified context is not a valid OpenCL context.
-   `"out_of_resources"`: If there is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: If there is a failure to allocate resources required by the OpenCL implementation on the host.

## Releasing a context

```zig
pub inline fn release(context: cl_context) errors.opencl_error!void;
```

#### Parameters

-   `context`: Specifies the OpenCL context to release.

#### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clReleaseContext` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_context"`: If the specified context is not a valid OpenCL context.
-   `"out_of_resources"`: If there is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: If there is a failure to allocate resources required by the OpenCL implementation on the host

