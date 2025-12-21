BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ai_interaction_log" (
    "id" bigserial PRIMARY KEY,
    "postId" bigint,
    "interactionType" text NOT NULL,
    "prompt" text NOT NULL,
    "model" text NOT NULL,
    "parameters" text NOT NULL,
    "rawResponse" text NOT NULL,
    "timingBreakdown" text NOT NULL,
    "success" boolean NOT NULL,
    "errorMessage" text,
    "createdAt" timestamp without time zone NOT NULL,
    "tokensUsed" bigint,
    "estimatedCostUsd" double precision
);

-- Indexes
CREATE INDEX "ai_log_post_idx" ON "ai_interaction_log" USING btree ("postId");
CREATE INDEX "ai_log_created_at_idx" ON "ai_interaction_log" USING btree ("createdAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "company_profile" (
    "id" bigserial PRIMARY KEY,
    "organizationId" bigint NOT NULL,
    "name" text NOT NULL,
    "description" text,
    "brandVoice" text,
    "uploadedFiles" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "company_profile_organization_idx" ON "company_profile" USING btree ("organizationId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "organization" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "postizApiKey" text NOT NULL,
    "geminiApiKey" text,
    "settings" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "post" (
    "id" bigserial PRIMARY KEY,
    "organizationId" bigint NOT NULL,
    "userId" bigint NOT NULL,
    "companyProfileId" bigint NOT NULL,
    "productId" bigint,
    "title" text NOT NULL,
    "userPrompt" text NOT NULL,
    "aiGeneratedContent" text NOT NULL,
    "editedContent" text,
    "selectedPlatforms" text NOT NULL,
    "status" text NOT NULL,
    "scheduleTime" timestamp without time zone,
    "postizPostId" text,
    "postizWebhookData" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL,
    "publishedAt" timestamp without time zone
);

-- Indexes
CREATE INDEX "post_organization_idx" ON "post" USING btree ("organizationId");
CREATE INDEX "post_user_idx" ON "post" USING btree ("userId");
CREATE INDEX "post_company_profile_idx" ON "post" USING btree ("companyProfileId");
CREATE INDEX "post_status_idx" ON "post" USING btree ("status");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "product" (
    "id" bigserial PRIMARY KEY,
    "companyProfileId" bigint NOT NULL,
    "name" text NOT NULL,
    "description" text,
    "targetAudience" text,
    "keyFeatures" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "product_company_profile_idx" ON "product" USING btree ("companyProfileId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "social_media_connection" (
    "id" bigserial PRIMARY KEY,
    "organizationId" bigint NOT NULL,
    "platform" text NOT NULL,
    "platformUserId" text NOT NULL,
    "platformUsername" text NOT NULL,
    "postizIntegrationId" text NOT NULL,
    "isActive" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "lastUsed" timestamp without time zone
);

-- Indexes
CREATE INDEX "social_connection_organization_idx" ON "social_media_connection" USING btree ("organizationId");
CREATE INDEX "social_connection_platform_idx" ON "social_media_connection" USING btree ("platform");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "passwordHash" text NOT NULL,
    "fullName" text NOT NULL,
    "organizationId" bigint NOT NULL,
    "role" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "isActive" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_email_idx" ON "user" USING btree ("email");
CREATE INDEX "user_organization_idx" ON "user" USING btree ("organizationId");


--
-- MIGRATION VERSION FOR social_media_marketing
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('social_media_marketing', '20251220095456239', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251220095456239', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20251208110420531-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110420531-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
