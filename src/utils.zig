
const std = @import("std");
const cl = @import("cl.zig");
const opencl = cl.opencl;

pub fn build_enum(comptime T: type, comptime definition: []const [:0]const u8) type {
    comptime var number_of_fields: u32 = 0;
    comptime var i: u32 = 1;

    inline while (i < definition.len) : (i+=2) {
        if (@hasDecl(opencl, definition[i])) number_of_fields += 1;
    }

    comptime var fields: [number_of_fields]std.builtin.Type.EnumField = undefined;
    i = 0;
    comptime var j = 0;
    inline while (j < number_of_fields) : (i+=2){
        if (@hasDecl(opencl, definition[i + 1])){
            fields[j].name = definition[i];
            fields[j].value = @field(opencl, definition[i + 1]);
            j += 1;
        }
    }
    
    const my_new_enum = std.builtin.Type{
        .@"enum" = std.builtin.Type.Enum{
            .fields = &fields,
            .tag_type = T,
            .is_exhaustive = false,
            .decls = &[_]std.builtin.Type.Declaration{}
        }
    };

    return @Type(my_new_enum);
}

pub fn build_error_set(comptime enum_tag: anytype, comptime definition: []const [:0]const u8) type {
    comptime var fields_num: u32 = 0;
    comptime var i: u32 = 0;

    inline while (i < definition.len) : (i += 2) {
        if (@hasField(enum_tag, definition[i])) fields_num += 1;
    }

    comptime var error_set: [fields_num]std.builtin.Type.Error = undefined;
    i = 0;

    comptime var j: u32 = 0;
    inline while (i < definition.len) : (i += 2) {
        if (@hasField(enum_tag, definition[i])){
            error_set[j] = std.builtin.Type.Error{
                .name = definition[i]
            };
            j += 1;
        }
    }

    return @Type(std.builtin.Type{
        .error_set = &error_set
    });
}

pub fn get_attr_info(comptime T: anytype, comptime func: anytype,
    comptime param_name: anytype, id: anytype, allocator: std.mem.Allocator) !T {
    var size: usize = undefined;
    var attr: T = undefined;

    try func(id, param_name, 0, null, &size);

    const type_info = @typeInfo(T);
    if (type_info == .pointer) {
        attr = try allocator.alloc(type_info.pointer.child, size / @sizeOf(type_info.pointer.child));
        errdefer allocator.free(attr);

        try func(id, param_name, size, attr.ptr, null);
    }else{
        try func(id, param_name, size, &attr, null);
    }

    return attr;
}

pub inline fn release_attr_info(comptime T: anytype, allocator: std.mem.Allocator, attr: T) void {
    const attr_type_info = @typeInfo(T);
    if (attr_type_info != .pointer or attr_type_info.pointer.size == .one) {
        @compileError("This function only support arrays");
    }

    allocator.free(attr);
}
