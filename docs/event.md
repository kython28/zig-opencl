## Waiting for Multiple Events

### Description

The `wait_for_many` function waits for a list of events to complete. This function blocks until all specified events are completed.

```zig
pub fn wait_for_many(events: []cl_event) errors.opencl_error!void;
```

### Parameters

-   **events**: An array of `cl_event` objects that the function waits for. All events must complete before the function returns.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clWaitForEvents` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_value"`: The number of events is zero or the event list is null.
-   `"invalid_context"`: Events specified in the event list do not belong to the same context.
-   `"invalid_event"`: Event objects specified in the event list are not valid event objects.
-   `"exec_status_error_for_events_in_wait_list"`: The execution status of any of the events in the event list is a negative integer value (this error code is missing before version 1.1).
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Waiting for a Single Event

### Description

The `wait` function waits for a single event to complete. This function blocks until the specified event is completed.

```zig
pub fn wait(event: cl_event) errors.opencl_error!void;
```

### Parameters

-   **event**: A `cl_event` object that the function waits for. The event must complete before the function returns.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clWaitForEvents` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_value"`: The number of events is zero or the event list is null.
-   `"invalid_context"`: The event does not belong to the same context.
-   `"invalid_event"`: The event object is not a valid event object.
-   `"exec_status_error_for_events_in_wait_list"`: The execution status of the event is a negative integer value (this error code is missing before version 1.1).
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Retaining an Event

### Description

The `retain` function increments the reference count of an event object. This function ensures that the event object remains valid even if other references to it are released.

```zig
pub fn retain(event: cl_event) errors.opencl_error!void;
```

### Parameters

-   **event**: The `cl_event` object to be retained.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clRetainEvent` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_event"`: The event is not a valid event object.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

## Releasing an Event

### Description

The `release` function decrements the reference count of an event object. When the reference count becomes zero, the event object is deleted. This function ensures that resources are properly released when they are no longer needed.

```zig
pub fn release(event: cl_event) errors.opencl_error!void;
```

### Parameters

-   **event**: The `cl_event` object to be released.

### Error Handling

The function uses Zig's error handling features to manage potential OpenCL errors. If the function call to `clReleaseEvent` does not return `CL_SUCCESS`, an error is thrown. Possible errors include:

-   `"invalid_event"`: The event is not a valid event object.
-   `"out_of_resources"`: There is a failure to allocate resources required by the OpenCL implementation on the device.
-   `"out_of_host_memory"`: There is a failure to allocate resources required by the OpenCL implementation on the host.

