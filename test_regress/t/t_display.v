// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed into the Public Domain, for any use,
// without warranty, 2003 by Wilson Snyder.

module t;
   reg [40:0] quad; initial quad = 41'ha_bbbb_cccc;
   reg [80:0] wide; initial wide = 81'habc_1234_5678_1234_5678;
   reg [31:0] str; initial str = "\000\277\021\n";
   reg [47:0] str2; initial str2 = "\000what!";
   reg [79:0] str3; initial str3 = "\000hmmm!1234";
   reg [8:0]  nine; initial nine = 12;

   sub sub ();
   sub2 sub2 ();

   initial begin
      $write("[%0t] In %m: Hi\n", $time);
      sub.write_m;
      sub2.write_m;

      // Escapes
      $display("[%0t] Back \\ Quote \"", $time);  // Old bug when \" last on the line.

      // Display formatting
      $display("[%0t] %%b=%b %%0b=%0b  %%b=%b %%0b=%0b  %%b=%b %%0b=%0b", $time,
	       nine, nine, quad, quad, wide, wide);
      $display("[%0t] %%B=%B %%0B=%0B  %%B=%B %%0B=%0B  %%B=%B %%0B=%0B", $time,
	       nine, nine, quad, quad, wide, wide);
      $display("[%0t] %%d=%d %%0d=%0d  %%d=%d %%0d=%0d", $time,
	       nine, nine, quad, quad);
      $display("[%0t] %%D=%D %%0D=%0D  %%D=%D %%0D=%0D", $time,
	       nine, nine, quad, quad);
      $display("[%0t] %%h=%h %%0h=%0h  %%h=%h %%0h=%0h  %%h=%h %%0h=%0h", $time,
	       nine, nine, quad, quad, wide, wide);
      $display("[%0t] %%H=%H %%0H=%0H  %%H=%H %%0H=%0H  %%H=%H %%0H=%0H", $time,
	       nine, nine, quad, quad, wide, wide);
      $display("[%0t] %%o=%o %%0o=%0o  %%o=%o %%0o=%0o  %%o=%o %%0o=%0o", $time,
	       nine, nine, quad, quad, wide, wide);
      $display("[%0t] %%O=%O %%0O=%0O  %%O=%O %%0O=%0O  %%O=%O %%0O=%0o", $time,
	       nine, nine, quad, quad, wide, wide);
      $display("[%0t] %%x=%x %%0x=%0x  %%x=%x %%0x=%0x  %%x=%x %%0x=%0x", $time,
	       nine, nine, quad, quad, wide, wide);
      $display("[%0t] %%X=%X %%0X=%0X  %%X=%X %%0X=%0X  %%X=%X %%0X=%0X", $time,
	       nine, nine, quad, quad, wide, wide);
      //
      $display("[%0t] %%D=%D %%d=%d %%01d=%01d %%06d=%06d %%6d=%6d", $time,
	       nine, nine, nine, nine, nine);
      $display("[%0t] %%t=%t %%03t=%03t %%0t=%0t", $time,
	       $time, $time, $time);
      $display;
      // Not testing %0s, it does different things in different simulators
      $display("[%0t] %%s=%s %%s=%s %%s=%s", $time,
	       str2[7:0], str2, str3);

      $display("[%0t] %s%s%s", $time,
	       "hel", "lo, fr", "om a very long string. Percent %s are literally substituted in.");
      $display("hel", "lo, fr", "om a concatenated string.");
      $write("hel", "lo, fr", "om a concatenated format string [%0t].\n", $time);
      $display("extra argument: ", $time);
      $write("[%0t] Embedded \r return\n", $time);
      $display("[%0t] Embedded\
multiline", $time);

      // Str check
`ifndef NC	// NC-Verilog 5.3 chokes on this test
      if (str !== 32'h00_bf_11_0a) $stop;
`endif
      $write("*-* All Finished *-*\n");
      $finish;
   end
endmodule

module sub;
   task write_m;
      begin
	 $write("[%0t] In %m\n", $time);
	 begin : subblock
	    $write("[%0t] In %M\n", $time); // Uppercase %M test
	 end
      end
   endtask
endmodule

module sub2;
   // verilator no_inline_module
   task write_m;
      begin
	 $write("[%0t] In %m\n", $time);
	 begin : subblock2
	    $write("[%0t] In %m\n", $time);
	 end
      end
   endtask
endmodule
