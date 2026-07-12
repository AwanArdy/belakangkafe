type t = {
  id: int;
  nama: string;
  no_hp: string option;
  email: string option;
  alamat: string option;
  tanggal_lahir: string option;
  jenis_kelamin: string option;
  posisi_id: int option;
  tanggal_bergabung: string;
  tipe_gaji: string;
  rate_gaji: string;
  no_rekening: string option;
  is_active: int;
  created_at: string option;
  updated_at: string option;
} [@@deriving yojson]
