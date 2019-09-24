let () =
  let _ = Sys.command "mkdir -p bar" in
  let bar_ml = open_out_bin "bar/dyn.ml" in
  output_string bar_ml {|
open Dune_action_plugin.V1

let action =
  let foo = read_file ~path:(Path.of_string "foo.ml") in
  foo |> stage ~f:(fun _ ->
    write_file
     ~path:(Path.of_string "bar.ml")
     ~data:("print_int Foo.x"))

let () = run action
|};
  close_out bar_ml;
  let dune = open_out_bin "bar/dune" in
  output_string dune {|
(executable (name dyn) (libraries dune._dune_action_plugin))

(alias (name bar) (action (dynamic-run ./bar.exe)))
|};
  close_out dune;
  let _ = Sys.command "dune build @bar" in
  ()
