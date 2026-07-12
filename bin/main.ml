let () =
  let _ = Lwt_main.run (
    let open Lwt.Syntax in
    let* res = Kafe_backend.Database.run_migrations () in
    match res with
    | Ok () ->
        Printf.printf "Migrasi database berhasil dijalankan.\n%!";
        Lwt.return_unit
    | Error err ->
        Printf.eprintf "Gagal menjalankan migrasi: %s\n%!" err;
        exit 1
  ) in

  Dream.run
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/" (fun _ ->
      Dream.html "Server Manajemen Kafe Berjalan!");
  ]
