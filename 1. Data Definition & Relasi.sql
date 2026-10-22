CREATE TABLE pengguna (
    id_pengguna   INT AUTO_INCREMENT PRIMARY KEY,
    nama          VARCHAR(100) NOT NULL,
    peran         ENUM('Admin','Guru','Siswa') NOT NULL,
    jurusan       VARCHAR(50)
);

CREATE TABLE komputer (
    id_komputer   INT AUTO_INCREMENT PRIMARY KEY,
    nama_komputer VARCHAR(50) NOT NULL,
    lokasi_lab    VARCHAR(50) NOT NULL,
    status        ENUM('Tersedia','Dipakai','Rusak') NOT NULL DEFAULT 'Tersedia'
);

CREATE TABLE sesi_login (
    id_sesi       INT AUTO_INCREMENT PRIMARY KEY,
    id_pengguna   INT NOT NULL,
    id_komputer   INT NOT NULL,
    waktu_login   DATETIME NOT NULL,
    waktu_logout  DATETIME,
    status_sesi   ENUM('Aktif','Selesai') NOT NULL DEFAULT 'Aktif',
    CONSTRAINT fk_sesi_pengguna FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna),
    CONSTRAINT fk_sesi_komputer FOREIGN KEY (id_komputer) REFERENCES komputer(id_komputer)
);
