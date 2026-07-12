type t = {
  id: int;
  nama_posisi: string;
  deskripsi: string option;
} [@@deriving yojson]
