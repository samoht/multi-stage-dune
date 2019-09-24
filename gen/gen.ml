let () =
  let bar_ml = open_out_bin "bar.ml" in
  output_string bar_ml "print_int Foo.x";
  close_out bar_ml;
  let dune = open_out_bin "dune" in
  output_string dune "(executable (name bar) (libraries foo))";
  close_out dune;
  let _ = Sys.command "dune exec -- ./bar.exe" in
  ()
