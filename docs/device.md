## Querying Devices

### Description

The `get_ids` function retrieves the list of available OpenCL devices on a specified platform. This function allows the application to query specific OpenCL devices or all OpenCL devices available on the platform.
```zig
pub fn getIds(
    platform: PlatformId,
    @"type": Type,
    devices: ?[]DeviceId,
    num_devices: ?*u32,
) OpenCLError!void;
```

#### Parameters

-   `platform`: The `PlatformId` for which the devices are being queried.
-   `@"type"`: An enumeration constant that identifies the type of OpenCL device. This is a member of the `Type` enum, which contains various device types. For example:
    -   `CL_DEVICE_TYPE_CPU` -> `cpu`
    -   `CL_DEVICE_TYPE_ALL` -> `all`
-   `devices`: A pointer to an array of `DeviceId` where the function will store the IDs of the available OpenCL devices. If `devices` is `null`, the function will not store the device IDs, but it will still return the number of available devices through `num_devices`.
-   `num_devices`: A pointer to a `u32` variable where the function will store the number of available OpenCL devices. If `num_devices` is `null`, this argument is ignored.

For a full list of the enum members, refer to the OpenCL PDF documentation or the `src/device.zig` file where the enums are defined.

#### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clGetDeviceIDs` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `InvalidValue`: The function was called with invalid parameters.
-   `OutOfHostMemory`: There is a failure to allocate resources required by the OpenCL implementation on the host.
-   `InvalidPlatform`: The specified platform is not valid.
-   `InvalidDeviceType`: The specified device type is not valid.
-   `DeviceNotFound`: No OpenCL devices matching the specified type were found.
-   `OutOfResources`: There is a failure to allocate resources required by the OpenCL implementation on the device.

## Querying Device Info

### Description

The `get_info` function retrieves specific information about an OpenCL device. This function is essential for obtaining various details about the device, such as its name, profile, version, and other attributes.

```zig
pub fn getInfo(
    device: DeviceId,
    param_name: Info,
    param_value_size: usize,
    param_value: ?*anyopaque,
    param_value_size_ret: ?*usize,
) OpenCLError!void;
```

#### Parameters

-   `device`: The `DeviceId` for which the information is being queried.
-   `param_name`: An enumeration constant that identifies the device information being queried. This is a member of the `Info` enum, which contains various attributes related to the device. For example:
    -   `CL_DEVICE_PROFILE` -> `profile`
    -   `CL_DEVICE_NAME` -> `name`
-   `param_value_size`: Specifies the size in bytes of memory pointed to by `param_value`.
-   `param_value`: A pointer to the memory location where the appropriate values for the given `param_name` will be returned. If `param_value` is `null`, it is ignored.
-   `param_value_size_ret`: Returns the actual size in bytes of data being queried by `param_name`. If `param_value_size_ret` is `null`, it is ignored.

For a full list of the enum members, refer to the OpenCL PDF documentation or the `src/device.zig` file where the enums are defined.

#### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clGetDeviceInfo` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `InvalidValue`: The function was called with invalid parameters.
-   `OutOfHostMemory`: There is a failure to allocate resources required by the OpenCL implementation on the host.
-   `InvalidDevice`: The specified device is not valid.
-   `OutOfResources`: There is a failure to allocate resources required by the OpenCL implementation on the device.

## Partitioning a Device

### Description

The `create_sub_devices` function creates sub-devices by partitioning an OpenCL device. This function is useful for dividing a device into multiple sub-devices that can be used independently.
```zig
pub fn createSubDevices(
    in_device: DeviceId,
    properties: []const PartitionProperty,
    out_devices: ?[]DeviceId,
    num_devices_ret: ?*u32,
) OpenCLError!void;
```

#### Parameters

-   `in_device`: The `DeviceId` of the device to be partitioned.
-   `properties`: Specifies how `in_device` is to be partitioned, described by a partition name and its corresponding value. This is a member of the `PartitionProperty` type. For example:
    -   `CL_DEVICE_PARTITION_BY_COUNTS` -> `by_counts`
    -   `CL_DEVICE_PARTITION_BY_AFFINITY_DOMAIN` -> `by_affinity_domain`
-   `out_devices`: A pointer to an array of `DeviceId` where the function will store the IDs of the created sub-devices. If `out_devices` is `null`, the function will not store the sub-device IDs, but it will still return the number of created sub-devices through `num_devices_ret`.
-   `num_devices_ret`: A pointer to a `u32` variable where the function will store the number of created sub-devices. If `num_devices_ret` is `null`, this argument is ignored.

For a full list of the enum members, refer to the OpenCL PDF documentation or the `src/device.zig` file where the enums are defined.

#### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clCreateSubDevices` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `InvalidValue`: The function was called with invalid parameters.
-   `OutOfHostMemory`: There is a failure to allocate resources required by the OpenCL implementation on the host.
-   `InvalidDevice`: The specified device is not valid.
-   `OutOfResources`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `DevicePartitionFailed`: The partition name is supported by the implementation but `in_device` could not be further partitioned.
-   `InvalidDevicePartitionCount`: The specified partition count is invalid or exceeds the available resources.

## Retaining a Device

### Description

The `retain` function increments the reference count of an OpenCL device if it is a valid sub-device created by a call to `clCreateSubDevices`. If the device is a root-level device (i.e., a `cl_device_id` returned by `clGetDeviceIDs`), the reference count remains unchanged.

```zig
pub fn retain(device: DeviceId) OpenCLError!void;
```

#### Parameters

-   `device`: The `DeviceId` of the OpenCL device to retain.

#### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clRetainDevice` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `InvalidDevice`: The specified device is not valid.
-   `OutOfHostMemory`: There is a failure to allocate resources required by the OpenCL implementation on the host.
-   `OutOfResources`: There is a failure to allocate resources required by the OpenCL implementation on the device.

## Releasing a Device

### Description

The `release` function releases an OpenCL device. If the device is a valid sub-device created by a call to `clCreateSubDevices`, it is released. If the device is a root-level device (i.e., a `cl_device_id` returned by `clGetDeviceIDs`), the release function ensures proper cleanup.

```zig
pub fn release(device: DeviceId) void;
```

#### Parameters

-   `device`: The `DeviceId` of the OpenCL device to release.

