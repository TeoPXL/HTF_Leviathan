import { defineConfig } from "drizzle-kit"
import 'dotenv/config'

export default defineConfig({
    dialect: "mysql",
    schema: "./src/db/schema.ts",
    dbCredentials: {
        host: process.env.DB_HOST ?? "host",
        port: 3306,
        user: process.env.MYSQL_USER ?? "user",
        password: process.env.MYSQL_PASSWORD ?? "password",
        database: process.env.MYSQL_DATABASE ?? "dbname",
    }
})