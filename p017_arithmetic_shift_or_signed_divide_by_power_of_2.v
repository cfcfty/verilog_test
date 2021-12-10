module arithmetic_right_shift_of_N_by_S_using_arithmetic_right_shift_operation
# (parameter N = 8, S = 3)
(input  [N - 1:0] a, output [N - 1:0] res);

  wire signed [N - 1:0] as = a;
  assign res = as >>> S;

endmodule

module arithmetic_right_shift_of_N_by_S_using_concatenation
# (parameter N = 8, S = 3)
(
  input  [N - 1:0] a,
  output [N - 1:0] res
);
  
  // TODO
  wire signed [N - 1:0] a_s = a;
  assign res = { { S { a_s[N - 1] } } , a_s[N - 1: N - S - 2] };
  
endmodule

module arithmetic_right_shift_of_N_by_S_using_for_inside_always
# (parameter N = 8, S = 3)
(
  input  [N - 1:0] a,
  output logic [N - 1:0] res
);

  // TODO
  wire signed [N - 1:0] a_s = a;
  
  always @*
   for (int i = N -1; i > -1; i --)
     res[i] = i > (N - 1 - S) ? a_s[N - 1] : a_s[i + S] ;
  
endmodule


module arithmetic_right_shift_of_N_by_S_using_for_inside_generate
    (parameter N = 8, S = 3)
    (
      input  [N - 1:0] a, 
      output [N - 1:0] res
    );
    
      wire signed [N - 1:0] a_s = a;
      
      genvar i;
    
      // Bad version
      generate
        for (i = N - 1; i > -1; i --)
          assign res[i] = i > (N - 1 - S) ? a_s[N - 1] : a_s[i + S] ;
      endgenerate
    
     //True version
    
      /*
       generate
          for (i = 0; i < N; i ++)
            if (i >= N - S)
              assign res [i] = a_s[N - 1];
            else
              assign res [i] = a_s[i + S];
        endgenerate
      */
      
    endmodule
  
endmodule

//----------------------------------------------------------------------------

module testbench;

  localparam N = 8, S = 3;

  logic signed [N - 1:0] a, res [0:3];

  arithmetic_right_shift_of_N_by_S_using_arithmetic_right_shift_operation
  # (.N (8), .S (3)) i4 (a, res [0]);

  arithmetic_right_shift_of_N_by_S_using_concatenation
  # (.N (8), .S (3)) i5 (a, res [1]);

  arithmetic_right_shift_of_N_by_S_using_for_inside_always
  # (.N (8), .S (3)) i6 (a, res [2]);

  arithmetic_right_shift_of_N_by_S_using_for_inside_generate
  # (.N (8), .S (3)) i7 (a, res [3]);

  initial
  begin
    repeat (20)
    begin
      a = $urandom ();
      # 1

      $write ("TEST %d %b", a, a);

      for (int i = 0; i < 4; i ++)
        $write (" %d %b", res [i], res [i]);

      $display;

      for (int i = 1; i < 4; i ++)
        if (res [i] !== res [0])
        begin
          $display ("%s FAIL. EXPECTED %d %b",
            `__FILE__, res [0], res [0]);

          $finish;
        end

        
        if (res [i] !== a / 2 ** S)
        begin
          $display ("%s FAIL. EXPECTED %d %b",
            `__FILE__, a / (8'sd2 ** S), a / (8'sd2 ** S));

          $finish;
        end
        
    end

    $display ("%s PASS", `__FILE__);
    $finish;
  end

endmodule
