import cors from 'cors';
require("dotenv").config();

const configCors = (app) => {
    const corsOptions = {
        origin: 'http://localhost:3000', // URL của client
        methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
        allowedHeaders: ['Content-Type', 'Authorization'],
        credentials: true
    };

    app.use(cors(corsOptions));
    app.options('*', cors(corsOptions));
};

export default configCors;
