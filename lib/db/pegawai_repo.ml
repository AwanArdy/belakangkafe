open Caqti_request.Infix
open Caqti_type.Std

let pegawai_type =
  let encode (m: Pegawai.t) = Ok (
    (m.id, m.nama, m.no_hp, m.email),
    (m.alamat, m.tanggal_lahir, m.jenis_kelamin, m.posisi_id),
    (m.tanggal_bergabung, m.tipe_gaji, m.rate_gaji, m.no_rekening),
    (m.is_active, m.created_at, m.updated_at)
  ) in
  let decode ((id, nama, no_hp, email),
              (alamat, tanggal_lahir, jenis_kelamin, posisi_id),
              (tanggal_bergabung, tipe_gaji, rate_gaji, no_rekening),
              (is_active, created_at, updated_at)) =
    Ok Pegawai.{ id; nama; no_hp; email; alamat; tanggal_lahir; jenis_kelamin; posisi_id;
                        tanggal_bergabung; tipe_gaji; rate_gaji; no_rekening; is_active; created_at; updated_at }
  in
  let pt1 = t4 int string (option string) (option string) in
  let pt2 = t4 (option string) (option string) (option string) (option int) in
  let pt3 = t4 string string string (option string) in
  let pt4 = t3 int (option string) (option string) in
  custom ~encode ~decode (t4 pt1 pt2 pt3 pt4)

let insert_type =
  t3
    (t4 string (option string) (option string) (option string))
    (t4 (option string) (option string) (option int) string)
    (t3 string string (option string))

let q_insert =
  (insert_type ->. unit)
  {| INSERT INTO pegawai
    (nama, no_hp, email, alamat, tanggal_lahir, jenis_kelamin, posisi_id, tanggal_bergabung, tipe_gaji, rate_gaji, no_rekening)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) |}

let q_get_all =
  (unit ->* pegawai_type)
  "SELECT * FROM pegawai WHERE is_active = 1"

let q_get_by_id =
  (int ->? pegawai_type)
  "SELECT * FROM pegawai WHERE id = ? AND is_active = 1"

let q_soft_delete =
  (int ->. unit)
  "UPDATE pegawai SET is_active = 0, updated_at = CURRENT_TIMESTAMP WHERE id  = ?"

let insert (p: Pegawai.t) (module Db: Caqti_lwt.CONNECTION) =
  let params = (
    (p.nama, p.no_hp, p.email, p.alamat),
    (p.tanggal_lahir, p.jenis_kelamin, p.posisi_id, p.tanggal_bergabung),
    (p.tipe_gaji, p.rate_gaji, p.no_rekening)
  ) in
  Db.exec q_insert params

let get all () (module Db: Caqti_lwt.CONNECTION) =
  Db.collect_list q_get_all

let get_by_id id (module Db: Caqti_lwt.CONNECTION) =
  Db.find_opt q_get_by_id id

let soft_delete id (module Db: Caqti_lwt.CONNECTION) =
  Db.exec q_soft_delete id
