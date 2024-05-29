# Introduction

This is a wrapper designed to use OpenCL functions from the Zig programming language, taking advantage of several language features that make the development of applications using OpenCL easy and safe. Zig's modern features, such as robust error handling, type safety, and slices, provide a more user-friendly and secure way to interact with OpenCL compared to traditional C interfaces.

To construct this wrapper, I based my work on the official [OpenCL API Specification](https://registry.khronos.org/OpenCL/specs/3.0-unified/pdf/OpenCL_API.pdf) document, which provides comprehensive details on how to use OpenCL. This specification is the authoritative source for understanding the capabilities and usage patterns of OpenCL, ensuring that the wrapper adheres to standard practices and is compatible with the latest OpenCL versions.

Normally, to use this wrapper effectively, you will need to refer to the aforementioned PDF, as it contains important information about how everything works.

Additionally, this wrapper was created with minimal abstraction. It is primarily limited to calling OpenCL functions, performing some validations such as function return checks to identify errors, and a few other minor tasks.

### Table of Contents

- [Functions for Platform Operations](platform.md)
- [Functions for Creating and Managing Devices](device.md)
- [Functions for Context Management](context.md)
- [Functions for Event Management](event.md)
- [Functions for Command Queues](command_queue.md)
- [Functions for Program Management](program.md)
- [Functions for Kernel Management](kernel.md)
- [Functions for Buffer Management](buffer.md)
- [Examples](examples.md)


## Note ⚠️

This wrapper does not include all existing OpenCL functions. It was specifically created for use in my projects, and therefore, only includes the functions I frequently use. If you need a function that is not included, please open an issue, and I will be happy to add it. Alternatively, if you would like to collaborate, feel free to create a pull request, and I will review and include it in the repository.
