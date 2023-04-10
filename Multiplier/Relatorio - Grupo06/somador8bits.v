module somador8bits(a,b,cin,sum,cout);
    parameter N = 8;
    input [N-1:0] a,b;
    input cin;
    output cout;
    output [N-1:0] sum;

    wire c0,c1,c2,c3,c4,c5,c6;

    somadorcompleto fa0 (.a(a[0]),.b(b[0]),.cin(cin),.cout(c0),.sum(sum[0]));
    somadorcompleto fa1 (.a(a[1]),.b(b[1]),.cin(c0),.cout(c1),.sum(sum[1]));
    somadorcompleto fa2 (.a(a[2]),.b(b[2]),.cin(c1),.cout(c2),.sum(sum[2]));
    somadorcompleto fa3 (.a(a[3]),.b(b[3]),.cin(c2),.cout(c3),.sum(sum[3]));
    somadorcompleto fa4 (.a(a[4]),.b(b[4]),.cin(c3),.cout(c4),.sum(sum[4]));
    somadorcompleto fa5 (.a(a[5]),.b(b[5]),.cin(c4),.cout(c5),.sum(sum[5]));
    somadorcompleto fa6 (.a(a[6]),.b(b[6]),.cin(c5),.cout(c6),.sum(sum[6]));
    somadorcompleto fa7 (.a(a[7]),.b(b[7]),.cin(c6),.cout(cout),.sum(sum[7]));

endmodule
