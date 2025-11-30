# Examples of Using the OpenCL Zig Wrapper

## Introduction

This guide provides practical examples of how to use the OpenCL Zig wrapper to perform common tasks in parallel computing. The OpenCL Zig wrapper simplifies the interaction with OpenCL, making it easier to harness the power of heterogeneous computing platforms including CPUs, GPUs, and other processors. Each example in this guide demonstrates a specific aspect of using the library, from querying platforms and devices to creating contexts and command queues, compiling programs, creating buffers, and executing kernels. These examples serve as a starting point for developers looking to integrate OpenCL capabilities into their Zig applications.

## Examples

### 1. Getting the List of Platforms

To get the list of available platforms using the OpenCL Zig wrapper, you can use the following function. This example shows how to retrieve and list the platforms:

```zig
const cl = @import("opencl");

// ...

const platforms: []cl.platform.Details = try cl.platform.getAll(allocator);
defer cl.platform.releaseList(allocator, platforms);

for (platforms) |platform| {
    const fields = @typeInfo(@TypeOf(platform)).@"struct".fields;
    inline for (fields) |field| {
        if (field.type == cl.platform.cl_platform_id) continue;
        print("{s} = {s}\n", .{field.name, @field(platform, field.name)});
    }
} 
```

### 2. Getting the List of Devices

After obtaining the platform, the next step is to get the list of available devices on that platform. The following example shows how to do it using the OpenCL Zig wrapper:

```zig
const cl = @import("opencl");

// ...

var number_of_devices: u32 = undefined;

try cl.device.getIds(platform_id, cl.device.Type.all, null, &number_of_devices);

const devices: []cl.device.DeviceId = try allocator.alloc(cl.device.DeviceId, number_of_devices);
defer allocator.free(devices);

try cl.device.getIds(platform_id, cl.device.Type.all, devices, null);
```

### 3. Creating a Context and Command Queue

With the platform and device ready, the next step is to create a context and a command queue. This example demonstrates how to do this using the OpenCL Zig wrapper:

```zig
const cl = @import("opencl");

const context: cl.context.Context = try cl.context.create(null, devices, null, null);
defer cl.context.release(context);

const cmd = try cl.command_queue.create(context, device, 0);
defer cl.command_queue.release(cmd);
```

### 4. Creating a Program

To create a program, you need to load the source code and build the program for the selected device. The following example shows how to do this using the OpenCL Zig wrapper:

```zig
const cl = @import("opencl");
const std = @import("std");

// ...

const file = try std.fs.cwd().openFile("tests.cl", .{});
defer file.close();

const metadata = try file.metadata();
const file_size = metadata.size();

const file_content: []u8 = try allocator.alloc(u8, file_size);
defer allocator.free(file_content);

_ = try file.read(file_content);

print("{s}\n", .{file_content});

const sources_list = &[_][]const u8{file_content};
const program = try cl.program.createWithSource(
    context, sources_list, allocator
);
defer cl.program.release(program);

cl.program.build(program, &[_]cl.device.DeviceId{device}, null, null, null) catch |err| {
    if (err == cl.errors.OpenCLError.BuildProgramFailure) {
        var build_log_size: usize = undefined;
        try cl.program.get_build_info(program, device, cl.program.BuildInfo.build_log, 0, null, &build_log_size);

        const build_log: []u8 = try allocator.alloc(u8, build_log_size);
        defer allocator.free(build_log);

        try cl.program.get_build_info(program, device, cl.program.BuildInfo.build_log, build_log_size, build_log.ptr, null);

        print("Error message: {s}\n", .{build_log});
    }

    return;
};
```

### 5. Creating a Buffer and Mapping It

Creating a buffer and mapping it to host memory is essential for data transfer between the host and the device. The following example demonstrates how to do this using the OpenCL Zig wrapper:

```zig
const cl = @import("opencl");

// ...

const buff = try cl.buffer.create(
    context, cl.buffer.MemFlag.read_write,
    32 * @sizeOf(i32), null
);
defer cl.buffer.release(buff);

var buff_map: []i32 = try cl.buffer.map(
    []i32, cmd, buff, true,
    cl.buffer.MapFlag.read | cl.buffer.MapFlag.write,
    0, 32 * @sizeOf(i32), null, null
);
defer {
    cl.buffer.unmap([]i32, cmd, buff, buff_map, null, null) catch {
        unreachable;
    };
}

buff_map[0] = 1;
buff_map[6] = 32;
buff_map[7] = 91;
```

### 6. Executing a Kernel

Finally, to execute a kernel, you need to set the kernel arguments and enqueue the kernel for execution. The following example shows how to do this using the OpenCL Zig wrapper:

```zig
const cl = @import("cl");

// ...

const kernel: cl.kernel.Kernel = try cl.kernel.create(program, "test_kernel");
defer cl.kernel.release(kernel);

try cl.kernel.setArg(kernel, 0,  @sizeOf(cl.buffer.Mem), @ptrCast(&buff1));
try cl.kernel.setArg(kernel, 1,  @sizeOf(cl.buffer.Mem), @ptrCast(&buff2));

try cl.kernel.enqueueNdRange(cmd, kernel, null, &[_]usize{8}, &[_]usize{8}, null, &event);
defer cl.event.release(event);

try cl.event.wait(event);
```

