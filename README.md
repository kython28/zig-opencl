# OpenCL Wrapper for Zig
A modern OpenCL wrapper for Zig language, providing easy-to-use interfaces for OpenCL functionalities.

## Getting Started
### Prerequisites
-   Zig 0.13.0 or higher
-   OpenCL 1.0 or higher

### Installation
To include this wrapper in your Zig project as a submodule, follow these steps:
1. **Edit your `build.zig.zon`:**
Add the `zig-opencl` dependency to your `build.zig.zon` file, similar to the following:
```zig
.{
    // ......
    .dependencies = .{
        .@"zig-opencl" = .{
            .url = "https://github.com/kython28/zig-opencl/archive/refs/tags/v0.3.0.tar.gz",
            .hash = "1220f5e5f896607483e5177125f8b6bdf4343d37b4c0bccbe6733f545fafe9a60345",
        },
    },
    // .....
}
```
2. **Edit your `build.zig`:**
Configure your `build.zig` file to include the `zig-opencl` module:
```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const package = b.dependency("zig-opencl", .{
        .target = target,
        .optimize = optimize
    });

    const module = package.module("opencl");

    const app = b.addExecutable(.{
        .name = "test-opencl",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize
    });

    app.root_module.addImport("opencl", module);

    b.installArtifact(app);
}
```
3. **Build the project:**
Now you can build your project using Zig:
```bash
zig build
```
This setup will allow you to use the `zig-opencl` wrapper in your project.

### How to Use
This OpenCL wrapper for Zig leverages several features of the Zig programming language, such as error handling and slices, to provide a safer and easier-to-use interface compared to the traditional C approach. For detailed documentation, please refer to the [Documentation](docs/introduction.md).

### Note ⚠️
This wrapper does not include all existing OpenCL functions. It was specifically created for use in my projects, and therefore, only includes the functions I frequently use. If you need a function that is not included, please open an issue, and I will be happy to add it. Alternatively, if you would like to collaborate, feel free to create a pull request, and I will review and include it in the repository.

