/*
  Warnings:

  - The values [Admin] on the enum `Role` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `createAT` on the `User` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAT` on the `User` table. All the data in the column will be lost.
  - Added the required column `tenantId` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "Role_new" AS ENUM ('USER', 'ADMIN');
ALTER TABLE "public"."User" ALTER COLUMN "role" DROP DEFAULT;
ALTER TABLE "User" ALTER COLUMN "role" TYPE "Role_new" USING ("role"::text::"Role_new");
ALTER TYPE "Role" RENAME TO "Role_old";
ALTER TYPE "Role_new" RENAME TO "Role";
DROP TYPE "public"."Role_old";
ALTER TABLE "User" ALTER COLUMN "role" SET DEFAULT 'USER';
COMMIT;

-- AlterTable
ALTER TABLE "User" DROP COLUMN "createAT",
DROP COLUMN "updatedAT",
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "tenantId" INTEGER NOT NULL,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- CreateTable
CREATE TABLE "Tenant" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Tenant_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
