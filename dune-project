(lang dune 3.24)
(name kafe_backend)
(generate_opam_files true)

(package
 (name kafe_backend)
 (synopsis "Backend API Manajemen Pegawai Kafe")
 (description "REST API untuk mengelola staf kafe, jadwal shift, presensi, cuti, dan gaji menggunakan OCaml dan SQLite")
 (depends
  (ocaml (>= 4.14.0))
  (dream (>= 1.0.0~alpha5))
  (caqti (>= 2.0.1))
  (caqti-lwt (>= 2.0.1))
  (caqti-driver-sqlite3 (>= 2.0.1))
  (yojson (>= 2.1.0))
  (ppx_deriving_yojson (>= 3.7.0))
  (safepass (>= 3.1))
  (alcotest :with-test)
 )
)

(source
 (github username/reponame))

(authors "Author Name <author@example.com>")

(maintainers "Maintainer Name <maintainer@example.com>")

(license LICENSE)

(documentation https://url/to/documentation)
; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
