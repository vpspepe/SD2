#!/usr/bin/env python3
import itertools


width = 8
a_width = width
b_width = width
z_width = a_width + b_width

print("module Multiplier(a, b, z);")
print("    input [{}:0] a;".format(a_width - 1))
print("    input [{}:0] b;".format(b_width - 1))
print("    output reg [{}:0] z;".format(z_width - 1))
print()
print("    always @(a, b) begin")
print("        case ({a, b})")

fmt = "            {{4}}'b{{3:0{0}b}}: z <= {{4}}'b{{2:0{0}b}}; // {{0}} * {{1}} = {{2}}".format(z_width)
for a, b in itertools.product(range(2 ** a_width), range(2 ** b_width)):
    sel = (a << b_width) + b
    z = a * b
    print(fmt.format(a, b, z, sel, z_width))


print("            default: z <= 0;")
print("        endcase")
print("    end")
print("endmodule")