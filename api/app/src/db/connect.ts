import mysql from "mysql2/promise"
import {dbConfig} from "./config"
import {drizzle} from "drizzle-orm/mysql2"

export async function setupDatabase() {
    // Create a connection pool for regular operations
    console.log("🔄 Creating connection pool for regular operations...")
    const poolConnection = mysql.createPool({
        ...dbConfig,
        waitForConnections: true,
        connectionLimit: 10,
        queueLimit: 0,
    })

    // Test the pool connection
    try {
        await poolConnection.getConnection()
        console.log("✅ Pool connection established successfully")
    } catch (error) {
        console.error("❌ Pool connection failed:", error)
        throw error
    }

    // Create and return the pooled Drizzle instance
    return drizzle({ client: poolConnection })
}