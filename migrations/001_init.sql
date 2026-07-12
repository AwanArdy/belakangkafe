-- ============================================
-- 1. POSISI (role staf kafe)
-- ============================================
CREATE TABLE posisi (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nama_posisi TEXT UNIQUE NOT NULL,      
    deskripsi TEXT
);

-- ============================================
-- 2. PEGAWAI
-- ============================================
CREATE TABLE pegawai (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nama TEXT NOT NULL,
    no_hp TEXT,
    email TEXT,
    alamat TEXT,
    tanggal_lahir TEXT,
    jenis_kelamin TEXT CHECK (jenis_kelamin IN ('L','P')),
    posisi_id INTEGER REFERENCES posisi(id),
    tanggal_bergabung TEXT NOT NULL,
    tipe_gaji TEXT NOT NULL CHECK (tipe_gaji IN ('bulanan','harian','per_jam')),
    rate_gaji REAL NOT NULL,               
    no_rekening TEXT,
    is_active INTEGER NOT NULL DEFAULT 1,  
    created_at TEXT DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 3. SHIFT (referensi jam kerja)
-- ============================================
CREATE TABLE shift (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nama_shift TEXT NOT NULL,              
    jam_mulai TEXT NOT NULL,               
    jam_selesai TEXT NOT NULL
);

-- ============================================
-- 4. JADWAL KERJA (penugasan pegawai ke shift per tanggal)
-- ============================================
CREATE TABLE jadwal_kerja (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pegawai_id INTEGER NOT NULL REFERENCES pegawai(id),
    shift_id INTEGER NOT NULL REFERENCES shift(id),
    tanggal TEXT NOT NULL,                 
    status TEXT NOT NULL DEFAULT 'dijadwalkan' CHECK (status IN ('dijadwalkan','selesai','dibatalkan')),
    UNIQUE (pegawai_id, tanggal, shift_id)
);

-- ============================================
-- 5. PRESENSI (absen masuk/pulang)
-- ============================================
CREATE TABLE presensi (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pegawai_id INTEGER NOT NULL REFERENCES pegawai(id),
    jadwal_kerja_id INTEGER REFERENCES jadwal_kerja(id),  
    tanggal TEXT NOT NULL,
    jam_masuk TEXT,                        
    jam_keluar TEXT,                       
    status TEXT NOT NULL DEFAULT 'hadir' CHECK (status IN ('hadir','telat','tidak_hadir','izin','sakit')),
    catatan TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 6. CUTI_IZIN (pengajuan cuti/izin/sakit)
-- ============================================
CREATE TABLE cuti_izin (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    pegawai_id INTEGER NOT NULL REFERENCES pegawai(id),
    jenis TEXT NOT NULL CHECK (jenis IN ('Cuti','Izin','Sakit')),
    tanggal_mulai TEXT NOT NULL,
    tanggal_selesai TEXT NOT NULL,
    alasan TEXT,
    status TEXT NOT NULL DEFAULT 'diajukan' CHECK (status IN ('diajukan','disetujui','ditolak')),
    disetujui_oleh INTEGER REFERENCES pegawai(id),
    catatan_approval TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 7. GAJI_PERIODE (satu siklus payroll)
-- ============================================
CREATE TABLE gaji_periode (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    periode_mulai TEXT NOT NULL,
    periode_selesai TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','final')),
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 8. SLIP_GAJI (hasil perhitungan)
-- ============================================
CREATE TABLE slip_gaji (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    gaji_periode_id INTEGER NOT NULL REFERENCES gaji_periode(id),
    pegawai_id INTEGER NOT NULL REFERENCES pegawai(id),
    total_jam_kerja REAL DEFAULT 0,
    total_hari_kerja INTEGER DEFAULT 0,
    gaji_pokok REAL NOT NULL,
    potongan REAL DEFAULT 0,               
    tunjangan REAL DEFAULT 0,              
    total_gaji REAL NOT NULL,
    status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','dibayar')),
    tanggal_dibayar TEXT,
    UNIQUE (gaji_periode_id, pegawai_id)
);

-- ============================================
-- 9. USERS (autentikasi & akses)
-- ============================================
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('admin','manager','pegawai')),
    pegawai_id INTEGER REFERENCES pegawai(id),
    last_login TEXT,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_presensi_pegawai_tanggal ON presensi(pegawai_id, tanggal);
CREATE INDEX idx_jadwal_kerja_tanggal ON jadwal_kerja(tanggal);
CREATE INDEX idx_cuti_izin_pegawai_status ON cuti_izin(pegawai_id, status);
