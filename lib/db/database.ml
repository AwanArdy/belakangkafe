let db_uri = Uri.of_string "sqlite3:kafe.db"

let pool = 
  match Caqti_lwt_unix.connect_pool db_uri with
  | Ok pool -> pool
  | Error err -> failwith (Caqti_error.show err)

let query f =
  let open Lwt.Syntax in
  let* result = Caqti_lwt_unix.Pool.use f pool in
  match result with
  | Ok data -> Lwt.return (Ok data)
  | Error err -> Lwt.return (Error (Caqti_error.show err))

let read_file filename =
  let ch = open_in filename in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch;
  s

let run_migrations () =
  let open Lwt.Syntax in
  let files = [
    "migrations/001_init.sql";
    "migrations/002_seed_posisi_shift.sql"
  ] in

  let rec execute_statements stmts (module Db : Caqti_lwt.CONNECTION) =
    match stmts with
    | [] -> Lwt.return (Ok ())
    | stmt :: rest ->
        if stmt = "" then execute_statements rest (module Db)
        else
          let req = 
            Caqti_request.Infix.(Caqti_type.unit ->. Caqti_type.unit) ~oneshot:true stmt 
          in
          let* result = Db.exec req () in
          match result with
          | Ok () -> execute_statements rest (module Db)
          | Error e -> Lwt.return (Error e)
  in

  let rec process_files = function
    | [] -> Lwt.return (Ok ())
    | file :: rest ->
        if Sys.file_exists file then
          let content = read_file file in

          let statements =
            String.split_on_char ';' content
            |> List.map String.trim
            |> List.filter (fun s -> s <> "")
          in
          let* res = query (fun db -> execute_statements statements db) in
          match res with
          | Ok () -> process_files rest
          | Error e -> Lwt.return (Error e)
        else
          process_files rest
  in

  process_files files
