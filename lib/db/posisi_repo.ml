open Caqti_request.Infix
open Caqti_type.Std

let posisi_type =
  let encode (m: Posisi.t) = Ok (m.id, m.nama_posisi, m.deskripsi) in
  let decode (id, nama_posisi, deskripsi) = Ok Posisi.{ id; nama_posisi; deskripsi } in
  custom ~encode ~decode (t3 int string (option string))

let q_insert =
  (t2 string (option string) ->. unit)
  "INSERT INTO posisi (nama_posisi, deskripsi) VALUES (?, ?)"

let q_get_all =
  (unit ->* posisi_type)
  "SELECT id, nama_posisi, deskripsi FROM posisi"

let insert nama_posisi deskripsi (module Db: Caqti_lwt.CONNECTION) =
  Db.exec q_insert (nama_posisi, deskripsi)

let get_all () (module Db: Caqti_lwt.CONNECTION) =
  Db.collect_list q_get_all ()
