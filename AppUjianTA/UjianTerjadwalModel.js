// Untuk koneksi ke MongoDB
const dbo = require("./conn");
// Konversi string ke ObjectId di MongoDB
const {ObjectId} = require("mongodb");

// Class Model yang bertugas memanipulasi data pada database sesuai dengan permintaan dari middleware
class UjianTerjadwalModel {

    constructor() {
        this.collectionName = "ujian_terjadwal";
    }

    getDb() {
        return dbo.getDb();
    }

    findAll() {
        // MongoDB Database Object
        let db = this.getDb();
        // Query
        // .. lengkapi logika kode dengan query yang sesuai di sini ..
        let query = {nim_anggota: 0, nama_anggota: 0, id_sesi: 0, waktu_mulai: 0,
        waktu_selesai: 0, tanggal: 0, keterangan_ruang: 0};
        return db.collection(this.collectionName).find({}, {projection: query});
    }

    findOneById(id, callback) {
        // MongoDB Database Object
        let db = this.getDb();
        // Query
        // .. lengkapi logika kode dengan query yang sesuai di sini ..
        let query = { _id: ObjectId(id) };
        db.collection(this.collectionName).findOne(query, callback);
    }

    addNew(obj, callback) {
        // MongoDB Database Object
        let db = this.getDb();
        // Query
        // .. lengkapi logika kode dengan query yang sesuai di sini ..
        db.collection(this.collectionName).insertOne(obj, callback);
    }

    edit(id, updatedObj, callback) {
        // MongoDB Database Object
        let db = this.getDb();
        // Query
        // .. lengkapi logika kode dengan query yang sesuai di sini ..
        console.log(updatedObj, id);
        return db.collection(this.collectionName).updateOne({_id: ObjectId(id)}, {$set: updatedObj}, callback);
    }

    deleteOneById(id, callback) {
        // MongoDB Database Object
        let db = this.getDb();
        // Query
        // .. lengkapi logika kode dengan query yang sesuai di sini ..
        return db.collection(this.collectionName).deleteOne({_id: ObjectId(id)}, callback);
    }
}

module.exports = new UjianTerjadwalModel();