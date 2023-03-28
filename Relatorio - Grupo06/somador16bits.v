module somador16bits(a,b,cin,sum,cout);
    parameter N = 16;
    input [7:0] a;
    input [N-1:0] b;
    input cin;
    output cout;
    output [N-1:0] sum;

    wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14;


    somadorcompleto fa0 (.a(a[0]),.b(b[0]),.cin(cin),.cout(c0),.sum(sum[0]));
    somadorcompleto fa1 (.a(a[1]),.b(b[1]),.cin(c0),.cout(c1),.sum(sum[1]));
    somadorcompleto fa2 (.a(a[2]),.b(b[2]),.cin(c1),.cout(c2),.sum(sum[2]));
    somadorcompleto fa3 (.a(a[3]),.b(b[3]),.cin(c2),.cout(c3),.sum(sum[3]));
    somadorcompleto fa4 (.a(a[4]),.b(b[4]),.cin(c3),.cout(c4),.sum(sum[4]));
    somadorcompleto fa5 (.a(a[5]),.b(b[5]),.cin(c4),.cout(c5),.sum(sum[5]));
    somadorcompleto fa6 (.a(a[6]),.b(b[6]),.cin(c5),.cout(c6),.sum(sum[6]));
    somadorcompleto fa7 (.a(a[7]),.b(b[7]),.cin(c6),.cout(c7),.sum(sum[7]));
    somadorcompleto fa8 (.a(1'b0),.b(b[8]),.cin(c7),.cout(c8),.sum(sum[8]));
    somadorcompleto fa9 (.a(1'b0),.b(b[9]),.cin(c8),.cout(c9),.sum(sum[9]));
    somadorcompleto fa10 (.a(1'b0),.b(b[10]),.cin(c9),.cout(c10),.sum(sum[10]));
    somadorcompleto fa11 (.a(1'b0),.b(b[11]),.cin(c10),.cout(c11),.sum(sum[11]));
    somadorcompleto fa12 (.a(1'b0),.b(b[12]),.cin(c11),.cout(c12),.sum(sum[12]));
    somadorcompleto fa13 (.a(1'b0),.b(b[13]),.cin(c12),.cout(c13),.sum(sum[13]));
    somadorcompleto fa14 (.a(1'b0),.b(b[14]),.cin(c13),.cout(c14),.sum(sum[14]));
    somadorcompleto fa15 (.a(1'b0),.b(b[15]),.cin(c14),.cout(cout),.sum(sum[15]));

    // Como a saída da soma deve possuir 16 bits e as entradas possuem 8 bits, incremetamos 
    // 8bits ao 'a' com valor 0, para que seja compatível com a saída de 16 bits.

endmodule
