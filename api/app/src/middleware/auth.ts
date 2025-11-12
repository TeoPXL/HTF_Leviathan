// middleware/auth.ts
import type { JwtPayload } from "./jwt"

export const authMiddleware = (db: any) =>
    async (ctx: any): Promise<JwtPayload | undefined> => {
        const { jwt, error, cookie: { auth } } = ctx

        const authToken = auth?.value
        if (!authToken) {
            //await logger.log(db, EventTypes.auth_failure)
            return error(401, "Unauthorized")
        }

        const payload = await jwt.verify(authToken)
        if (!payload) {
            //await logger.log(db, EventTypes.auth_failure)
            return error(401, "Unauthorized")
        }

        const decoded = payload as JwtPayload
        if (!decoded.user_id || !decoded.user_name || !decoded.role || !decoded.subscription) {
            //await logger.log(db, EventTypes.auth_failure)
            return error(401, "Invalid token payload")
        }

        return decoded
    }
