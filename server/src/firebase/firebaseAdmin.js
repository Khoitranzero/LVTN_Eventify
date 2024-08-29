// src/firebase/firebaseAdmin.js
import admin from 'firebase-admin';
import { readFileSync } from 'fs';
import { resolve } from 'path';


const serviceAccountPath = resolve(__dirname, './doan.json');
const serviceAccount = JSON.parse(readFileSync(serviceAccountPath, 'utf8'));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: ''
});

const authAdmin = admin.auth();

export { authAdmin };
