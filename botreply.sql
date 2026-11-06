-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Nov 06, 2026 at 07:30 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `botreply`
--

-- --------------------------------------------------------

--
-- Table structure for table `agents`
--

CREATE TABLE `agents` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `name` varchar(191) NOT NULL,
  `slug` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `type` enum('sales','support','booking','hr','router','custom') NOT NULL DEFAULT 'custom',
  `status` enum('draft','published','archived') NOT NULL DEFAULT 'draft',
  `current_version` int(11) NOT NULL DEFAULT 0,
  `created_by` varchar(36) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `agents`
--

INSERT INTO `agents` (`id`, `workspace_id`, `name`, `slug`, `description`, `type`, `status`, `current_version`, `created_by`, `created_at`, `updated_at`) VALUES
('0d72efde-f505-4f96-ac6d-e04235842656', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'Support agent', 'support-agent', 'Answers product and support questions from the knowledge base.', 'support', 'published', 1, '83a96de8-003d-438e-8cb8-b79e6abadbd1', '2026-10-20 08:57:48.196', '2026-10-20 08:57:48.196'),
('67dfa8ec-4786-4dba-8554-307742710dcb', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'CRUD smoke agent v2', 'crud-smoke-agent-v2', 'Renamed', 'support', 'archived', 1, '83a96de8-003d-438e-8cb8-b79e6abadbd1', '2026-10-20 10:18:28.839', '2026-10-20 10:18:29.073'),
('96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'sales agent', 'sales-agent', 'kk ', 'sales', 'published', 1, '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-20 10:01:02.972', '2026-10-29 12:13:06.907'),
('agent-1', 'ws-1', 'Support Agent', 'support-agent', 'Answers customer questions', 'support', 'published', 1, 'user-1', '2026-10-29 14:33:00.349', '2026-10-29 14:33:00.349'),
('agent-2', 'ws-2', 'Sales Agent', 'sales-agent', 'Handles lead qualification', 'sales', 'published', 1, 'user-2', '2026-10-29 14:33:00.349', '2026-10-29 14:33:00.349'),
('f803b4a0-5da6-4912-ba1d-4a8fb2af9638', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'HR AGENT', 'hr-agent', 'HR releated question answer bot  ', 'hr', 'published', 1, '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-29 12:14:31.570', '2026-10-29 14:13:31.276');

-- --------------------------------------------------------

--
-- Table structure for table `agent_tools`
--

CREATE TABLE `agent_tools` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `agent_id` varchar(36) NOT NULL,
  `tool_key` varchar(96) NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `input_schema` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`input_schema`)),
  `handler` enum('create_lead','create_booking','create_ticket','search_knowledge','add_tag','assign_conversation','http_request') NOT NULL,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`config`)),
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `agent_tools`
--

INSERT INTO `agent_tools` (`id`, `workspace_id`, `agent_id`, `tool_key`, `name`, `description`, `input_schema`, `handler`, `config`, `enabled`, `created_at`, `updated_at`) VALUES
('1cb31d0e-2039-46ea-b4f5-a448849757d5', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '67dfa8ec-4786-4dba-8554-307742710dcb', 'kb', 'Knowledge search', NULL, NULL, 'search_knowledge', NULL, 1, '2026-10-20 10:18:28.903', '2026-10-20 10:18:28.903'),
('450f152e-5bac-4429-8801-fff6de0c2524', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'search_knowledge', 'search_knowledge', 'Search the business knowledge base (policies, pricing, docs) and return the most relevant passages. Call this before answering factual questions.', NULL, 'search_knowledge', NULL, 1, '2026-10-20 11:53:59.551', '2026-10-20 11:53:59.551'),
('7fe1af7f-3507-43ff-aa11-d3d29191e348', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '67dfa8ec-4786-4dba-8554-307742710dcb', 'lead', 'Create lead', NULL, NULL, 'create_lead', NULL, 1, '2026-10-20 10:18:28.906', '2026-10-20 10:18:28.906'),
('d8003409-e770-48be-8e9c-d74b9429aeff', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'create_lead', 'create_lead', 'Record a sales lead when the customer shows buying intent. Also upserts the contact.', NULL, 'create_lead', NULL, 1, '2026-10-20 11:53:59.551', '2026-10-20 11:53:59.551');

-- --------------------------------------------------------

--
-- Table structure for table `agent_versions`
--

CREATE TABLE `agent_versions` (
  `id` varchar(36) NOT NULL,
  `agent_id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `version` int(11) NOT NULL,
  `status` enum('draft','published','archived') NOT NULL DEFAULT 'draft',
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`config`)),
  `note` varchar(255) DEFAULT NULL,
  `published_at` datetime(3) DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `agent_versions`
--

INSERT INTO `agent_versions` (`id`, `agent_id`, `workspace_id`, `version`, `status`, `config`, `note`, `published_at`, `created_by`, `created_at`) VALUES
('58d3ef60-2f60-45ca-84b6-8af87b088e05', '0d72efde-f505-4f96-ac6d-e04235842656', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 1, 'published', '{\"systemInstructions\":\"You are a concise, helpful customer support assistant for our product. Use only the supplied knowledge context. If the answer is not in the context, say you do not know and offer to connect the customer to a human.\",\"language\":\"en\",\"tone\":\"friendly\",\"temperature\":0.3,\"maxOutputTokens\":600,\"knowledgeSourceIds\":[],\"enabledTools\":[],\"escalation\":{\"onNoAnswer\":true,\"message\":\"Let me connect you with a human agent.\"},\"safety\":{\"refusePersonalDataRequests\":true,\"maxReplyChars\":1200}}', NULL, '2026-10-20 08:57:48.197', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '2026-10-20 08:57:48.197'),
('790773ca-d626-4c8d-9530-79d031e130ce', 'f803b4a0-5da6-4912-ba1d-4a8fb2af9638', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 2, 'draft', '{\"temperature\":0.3,\"maxTokens\":1024,\"language\":\"en\",\"systemPrompt\":\"\",\"enableKnowledge\":true,\"knowledgeSourceIds\":[\"ec2603eb-7ce9-48d0-8e6c-59193a7da3a6\"],\"knowledgeLimit\":5,\"respondOnlyFromKnowledge\":false,\"escalation\":{\"enabled\":true,\"keywords\":[\"human\",\"real person\",\"talk to someone\",\"agent\",\"manager\",\"call me\"],\"message\":\"Of course — I am connecting you with a human teammate who will pick this up shortly.\"}}', 'Knowledge sources linked', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-30 11:22:04.378'),
('87474e48-c46e-4997-931d-69b865399117', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 1, 'published', '{\"temperature\":0.3,\"maxTokens\":1024,\"language\":\"en\",\"systemPrompt\":\"\",\"enableKnowledge\":true,\"knowledgeSourceIds\":[],\"knowledgeLimit\":5,\"respondOnlyFromKnowledge\":false,\"escalation\":{\"enabled\":true,\"keywords\":[\"human\",\"real person\",\"talk to someone\",\"agent\",\"manager\",\"call me\"],\"message\":\"Of course — I am connecting you with a human teammate who will pick this up shortly.\"}}', 'Initial draft', '2026-10-24 15:00:47.504', '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-20 10:01:02.973'),
('c3ca8fdc-0f2e-4b54-9379-5f914ecd85da', '67dfa8ec-4786-4dba-8554-307742710dcb', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 1, 'published', '{\"temperature\":0.1,\"maxTokens\":512,\"language\":\"en\",\"systemPrompt\":\"Be extra concise. Answer in English.\",\"enableKnowledge\":true,\"knowledgeSourceIds\":[],\"knowledgeLimit\":4,\"respondOnlyFromKnowledge\":false,\"escalation\":{\"enabled\":true,\"keywords\":[\"human\",\"manager\"],\"message\":\"Connecting you now.\"}}', 'smoke draft', '2026-10-20 10:18:28.925', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '2026-10-20 10:18:28.880'),
('ca1e698f-559b-43b8-bc94-4d0d14ae31a1', 'f803b4a0-5da6-4912-ba1d-4a8fb2af9638', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 1, 'published', '{\"temperature\":0.3,\"maxTokens\":1024,\"language\":\"en\",\"systemPrompt\":\"\",\"enableKnowledge\":true,\"knowledgeSourceIds\":[],\"knowledgeLimit\":5,\"respondOnlyFromKnowledge\":false,\"escalation\":{\"enabled\":true,\"keywords\":[\"human\",\"real person\",\"talk to someone\",\"agent\",\"manager\",\"call me\"],\"message\":\"Of course — I am connecting you with a human teammate who will pick this up shortly.\"}}', 'Initial draft', '2026-10-29 14:13:21.708', '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-29 12:14:31.574');

-- --------------------------------------------------------

--
-- Table structure for table `api_keys`
--

CREATE TABLE `api_keys` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `name` varchar(191) NOT NULL,
  `key_prefix` varchar(16) NOT NULL,
  `key_hash` varchar(64) NOT NULL,
  `scopes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`scopes`)),
  `last_used_at` datetime(3) DEFAULT NULL,
  `revoked_at` datetime(3) DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `api_keys`
--

INSERT INTO `api_keys` (`id`, `workspace_id`, `name`, `key_prefix`, `key_hash`, `scopes`, `last_used_at`, `revoked_at`, `created_by`, `created_at`) VALUES
('ak-1', 'ws-1', 'API Key 1', 'btp_', 'keyhash-1', '[\"workspace.read\", \"workspace.write\"]', NULL, NULL, 'user-1', '2026-10-29 14:33:00.311'),
('ak-2', 'ws-2', 'API Key 2', 'btp_', 'keyhash-2', '[\"workspace.read\"]', NULL, NULL, 'user-2', '2026-10-29 14:33:00.311');

-- --------------------------------------------------------

--
-- Table structure for table `audit_events`
--

CREATE TABLE `audit_events` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) DEFAULT NULL,
  `actor_user_id` varchar(36) DEFAULT NULL,
  `actor_type` enum('user','api_key','system','webhook') NOT NULL DEFAULT 'user',
  `action` varchar(120) NOT NULL,
  `resource_type` varchar(64) DEFAULT NULL,
  `resource_id` varchar(36) DEFAULT NULL,
  `outcome` enum('success','failure') NOT NULL DEFAULT 'success',
  `ip` varchar(64) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_events`
--

INSERT INTO `audit_events` (`id`, `workspace_id`, `actor_user_id`, `actor_type`, `action`, `resource_type`, `resource_id`, `outcome`, `ip`, `user_agent`, `metadata`, `created_at`) VALUES
('00746355-4ede-48d1-9825-e88d7032b048', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.update', 'agent', 'f803b4a0-5da6-4912-ba1d-4a8fb2af9638', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-29 14:13:31.281'),
('0114d399-0aa3-496b-aeb6-023149eba28f', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.update', 'agent', 'f803b4a0-5da6-4912-ba1d-4a8fb2af9638', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-29 14:03:57.273'),
('014578e9-55b9-4918-a2ae-1ed0a2b476f0', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'auth.login', 'user', '59627376-d414-4b33-a8c5-756cf5d231a1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '{}', '2026-10-24 15:26:13.839'),
('02bd1631-4449-476b-92c1-4802cbf1991e', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.create', 'campaign', '4980cd90-21aa-48e1-89e0-301797004901', 'success', '::1', NULL, '{\"name\":\"Inspect test\",\"channelType\":\"whatsapp\",\"audienceMode\":\"manual\",\"matched\":1,\"deliverable\":1,\"suppressed\":0}', '2026-10-24 15:03:31.041'),
('032c2995-e3e8-40f4-a9f2-e18432e56278', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'agents.publish', 'agent', '67dfa8ec-4786-4dba-8554-307742710dcb', 'success', '::ffff:127.0.0.1', NULL, '{\"version\":1}', '2026-10-20 10:18:28.934'),
('04e6e95c-e3d7-4a76-9cbb-d75193c1bb48', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'auth.login', 'user', '59627376-d414-4b33-a8c5-756cf5d231a1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '{}', '2026-10-20 09:36:37.949'),
('04e7446c-91b6-4cbd-9afd-4cd6367ffe8c', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'flows.publish', 'flow', '863c7b68-700e-4430-8de0-7919e82d40b0', 'success', '::ffff:127.0.0.1', NULL, '{\"version\":1}', '2026-10-20 10:13:20.579'),
('0826ff48-7efc-4445-bb56-f02be7ae6e04', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-22 10:40:29.437'),
('097e1553-8c6d-4bca-bf0b-6ae37c940b9a', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.publish', 'agent', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'success', '::ffff:127.0.0.1', NULL, '{\"version\":1}', '2026-10-20 10:20:02.989'),
('0bb7c185-8af8-49a4-aad9-1f590f1dc045', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.cancel', 'campaign', '1cada601-5845-4665-817f-4f54af2d6a66', 'success', '::ffff:127.0.0.1', NULL, '{\"from\":\"scheduled\",\"to\":\"cancelled\"}', '2026-10-24 15:18:58.367'),
('0eaac386-7441-453f-bb27-b680dc4102a5', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.cancel', 'campaign', '13e39da4-595c-482f-926c-304f034f0771', 'success', '::ffff:127.0.0.1', NULL, '{\"from\":\"running\",\"to\":\"cancelled\"}', '2026-10-24 15:13:49.202'),
('0f68a411-74ad-46c3-a9d2-609a9941dfd7', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::ffff:127.0.0.1', 'node', '{}', '2026-10-24 15:18:57.974'),
('10fd4d64-84f4-4e7f-85f0-966d5f5c4655', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-20 10:18:52.913'),
('1262b6ce-a3d9-49cf-b158-e21cc922b676', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'agents.update', 'agent', '67dfa8ec-4786-4dba-8554-307742710dcb', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-20 10:18:28.865'),
('12642b2f-4687-4f74-a7f8-6b90f7dbf5ce', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.create', 'campaign', '4e0f088a-2775-4339-80fb-cc7c4f049529', 'success', '::1', NULL, '{\"name\":\"Dedup test\",\"channelType\":\"telegram\"}', '2026-10-24 14:55:56.652'),
('1380c277-943b-4c05-9fbd-80752b769e63', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'knowledge.source_create', 'knowledge_source', 'ec2603eb-7ce9-48d0-8e6c-59193a7da3a6', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"Services\",\"type\":\"text\"}', '2026-10-30 11:22:04.282'),
('14b51508-541a-4a27-a7fb-204508844d49', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.send', 'campaign', '79a798b2-9629-4b78-b500-55f871688992', 'success', '::1', NULL, '{\"scheduled\":false,\"runAt\":null}', '2026-10-24 15:06:33.639'),
('156189b8-158f-4638-b728-4b7a0aebb6ff', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'customer_portal.account_link', 'customer_account', 'b6bcd951-3a35-47b4-a49e-2762121e0c7d', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '{\"contactId\":\"f09e2fff-e1bc-4948-82a0-7de08bb0dde7\"}', '2026-10-22 11:13:21.138'),
('19054aaf-270b-46ed-90ed-1d8507d5d239', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'templates.create', 'template', '06920ea3-68a6-4168-ac82-4eabe50b32eb', 'success', '::1', NULL, '{\"name\":\"Greeting\",\"channelType\":\"whatsapp\",\"language\":\"en\"}', '2026-10-24 14:42:19.682'),
('194ab143-2c6c-4ab3-9126-e735b812d53a', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.update', 'channel', '867f36e8-1055-4685-9a2d-62fb410d4b05', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-24 14:53:07.527'),
('199800e8-8b66-46fe-8eb5-356f31569fd3', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'workspace.update', 'workspace', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'success', '::ffff:127.0.0.1', NULL, '{\"settings\":{\"0\":\"{\",\"1\":\"\\\"\",\"2\":\"t\",\"3\":\"i\",\"4\":\"m\",\"5\":\"e\",\"6\":\"z\",\"7\":\"o\",\"8\":\"n\",\"9\":\"e\",\"10\":\"\\\"\",\"11\":\":\",\"12\":\"\\\"\",\"13\":\"A\",\"14\":\"s\",\"15\":\"i\",\"16\":\"a\",\"17\":\"/\",\"18\":\"K\",\"19\":\"o\",\"20\":\"l\",\"21\":\"k\",\"22\":\"a\",\"23\":\"t\",\"24\":\"a\",\"25\":\"\\\"\",\"26\":\",\",\"27\":\"\\\"\",\"28\":\"l\",\"29\":\"o\",\"30\":\"c\",\"31\":\"a\",\"32\":\"l\",\"33\":\"e\",\"34\":\"\\\"\",\"35\":\":\",\"36\":\"\\\"\",\"37\":\"e\",\"38\":\"n\",\"39\":\"-\",\"40\":\"I\",\"41\":\"N\",\"42\":\"\\\"\",\"43\":\"}\",\"widgetChannelId\":\"867f36e8-1055-4685-9a2d-62fb410d4b05\"}}', '2026-10-22 06:17:33.526'),
('19e361fe-8c25-4810-b7b0-f75a34c1675c', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'workspace.plan_change', 'workspace', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'success', '::ffff:127.0.0.1', NULL, '{\"plan\":\"pro\"}', '2026-10-24 16:10:55.151'),
('1afd7b15-93b8-43af-a8cd-97aabf4d5ccd', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'workspace.update', 'workspace', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'success', '::ffff:127.0.0.1', NULL, '{\"settings\":{\"0\":\"{\",\"1\":\"\\\"\",\"2\":\"0\",\"3\":\"\\\"\",\"4\":\":\",\"5\":\"\\\"\",\"6\":\"{\",\"7\":\"\\\"\",\"8\":\",\",\"9\":\"\\\"\",\"10\":\"1\",\"11\":\"\\\"\",\"12\":\":\",\"13\":\"\\\"\",\"14\":\"\\\\\",\"15\":\"\\\"\",\"16\":\"\\\"\",\"17\":\",\",\"18\":\"\\\"\",\"19\":\"2\",\"20\":\"\\\"\",\"21\":\":\",\"22\":\"\\\"\",\"23\":\"t\",\"24\":\"\\\"\",\"25\":\",\",\"26\":\"\\\"\",\"27\":\"3\",\"28\":\"\\\"\",\"29\":\":\",\"30\":\"\\\"\",\"31\":\"i\",\"32\":\"\\\"\",\"33\":\",\",\"34\":\"\\\"\",\"35\":\"4\",\"36\":\"\\\"\",\"37\":\":\",\"38\":\"\\\"\",\"39\":\"m\",\"40\":\"\\\"\",\"41\":\",\",\"42\":\"\\\"\",\"43\":\"5\",\"44\":\"\\\"\",\"45\":\":\",\"46\":\"\\\"\",\"47\":\"e\",\"48\":\"\\\"\",\"49\":\",\",\"50\":\"\\\"\",\"51\":\"6\",\"52\":\"\\\"\",\"53\":\":\",\"54\":\"\\\"\",\"55\":\"z\",\"56\":\"\\\"\",\"57\":\",\",\"58\":\"\\\"\",\"59\":\"7\",\"60\":\"\\\"\",\"61\":\":\",\"62\":\"\\\"\",\"63\":\"o\",\"64\":\"\\\"\",\"65\":\",\",\"66\":\"\\\"\",\"67\":\"8\",\"68\":\"\\\"\",\"69\":\":\",\"70\":\"\\\"\",\"71\":\"n\",\"72\":\"\\\"\",\"73\":\",\",\"74\":\"\\\"\",\"75\":\"9\",\"76\":\"\\\"\",\"77\":\":\",\"78\":\"\\\"\",\"79\":\"e\",\"80\":\"\\\"\",\"81\":\",\",\"82\":\"\\\"\",\"83\":\"1\",\"84\":\"0\",\"85\":\"\\\"\",\"86\":\":\",\"87\":\"\\\"\",\"88\":\"\\\\\",\"89\":\"\\\"\",\"90\":\"\\\"\",\"91\":\",\",\"92\":\"\\\"\",\"93\":\"1\",\"94\":\"1\",\"95\":\"\\\"\",\"96\":\":\",\"97\":\"\\\"\",\"98\":\":\",\"99\":\"\\\"\",\"100\":\",\",\"101\":\"\\\"\",\"102\":\"1\",\"103\":\"2\",\"104\":\"\\\"\",\"105\":\":\",\"106\":\"\\\"\",\"107\":\"\\\\\",\"108\":\"\\\"\",\"109\":\"\\\"\",\"110\":\",\",\"111\":\"\\\"\",\"112\":\"1\",\"113\":\"3\",\"114\":\"\\\"\",\"115\":\":\",\"116\":\"\\\"\",\"117\":\"A\",\"118\":\"\\\"\",\"119\":\",\",\"120\":\"\\\"\",\"121\":\"1\",\"122\":\"4\",\"123\":\"\\\"\",\"124\":\":\",\"125\":\"\\\"\",\"126\":\"s\",\"127\":\"\\\"\",\"128\":\",\",\"129\":\"\\\"\",\"130\":\"1\",\"131\":\"5\",\"132\":\"\\\"\",\"133\":\":\",\"134\":\"\\\"\",\"135\":\"i\",\"136\":\"\\\"\",\"137\":\",\",\"138\":\"\\\"\",\"139\":\"1\",\"140\":\"6\",\"141\":\"\\\"\",\"142\":\":\",\"143\":\"\\\"\",\"144\":\"a\",\"145\":\"\\\"\",\"146\":\",\",\"147\":\"\\\"\",\"148\":\"1\",\"149\":\"7\",\"150\":\"\\\"\",\"151\":\":\",\"152\":\"\\\"\",\"153\":\"/\",\"154\":\"\\\"\",\"155\":\",\",\"156\":\"\\\"\",\"157\":\"1\",\"158\":\"8\",\"159\":\"\\\"\",\"160\":\":\",\"161\":\"\\\"\",\"162\":\"K\",\"163\":\"\\\"\",\"164\":\",\",\"165\":\"\\\"\",\"166\":\"1\",\"167\":\"9\",\"168\":\"\\\"\",\"169\":\":\",\"170\":\"\\\"\",\"171\":\"o\",\"172\":\"\\\"\",\"173\":\",\",\"174\":\"\\\"\",\"175\":\"2\",\"176\":\"0\",\"177\":\"\\\"\",\"178\":\":\",\"179\":\"\\\"\",\"180\":\"l\",\"181\":\"\\\"\",\"182\":\",\",\"183\":\"\\\"\",\"184\":\"2\",\"185\":\"1\",\"186\":\"\\\"\",\"187\":\":\",\"188\":\"\\\"\",\"189\":\"k\",\"190\":\"\\\"\",\"191\":\",\",\"192\":\"\\\"\",\"193\":\"2\",\"194\":\"2\",\"195\":\"\\\"\",\"196\":\":\",\"197\":\"\\\"\",\"198\":\"a\",\"199\":\"\\\"\",\"200\":\",\",\"201\":\"\\\"\",\"202\":\"2\",\"203\":\"3\",\"204\":\"\\\"\",\"205\":\":\",\"206\":\"\\\"\",\"207\":\"t\",\"208\":\"\\\"\",\"209\":\",\",\"210\":\"\\\"\",\"211\":\"2\",\"212\":\"4\",\"213\":\"\\\"\",\"214\":\":\",\"215\":\"\\\"\",\"216\":\"a\",\"217\":\"\\\"\",\"218\":\",\",\"219\":\"\\\"\",\"220\":\"2\",\"221\":\"5\",\"222\":\"\\\"\",\"223\":\":\",\"224\":\"\\\"\",\"225\":\"\\\\\",\"226\":\"\\\"\",\"227\":\"\\\"\",\"228\":\",\",\"229\":\"\\\"\",\"230\":\"2\",\"231\":\"6\",\"232\":\"\\\"\",\"233\":\":\",\"234\":\"\\\"\",\"235\":\",\",\"236\":\"\\\"\",\"237\":\",\",\"238\":\"\\\"\",\"239\":\"2\",\"240\":\"7\",\"241\":\"\\\"\",\"242\":\":\",\"243\":\"\\\"\",\"244\":\"\\\\\",\"245\":\"\\\"\",\"246\":\"\\\"\",\"247\":\",\",\"248\":\"\\\"\",\"249\":\"2\",\"250\":\"8\",\"251\":\"\\\"\",\"252\":\":\",\"253\":\"\\\"\",\"254\":\"l\",\"255\":\"\\\"\",\"256\":\",\",\"257\":\"\\\"\",\"258\":\"2\",\"259\":\"9\",\"260\":\"\\\"\",\"261\":\":\",\"262\":\"\\\"\",\"263\":\"o\",\"264\":\"\\\"\",\"265\":\",\",\"266\":\"\\\"\",\"267\":\"3\",\"268\":\"0\",\"269\":\"\\\"\",\"270\":\":\",\"271\":\"\\\"\",\"272\":\"c\",\"273\":\"\\\"\",\"274\":\",\",\"275\":\"\\\"\",\"276\":\"3\",\"277\":\"1\",\"278\":\"\\\"\",\"279\":\":\",\"280\":\"\\\"\",\"281\":\"a\",\"282\":\"\\\"\",\"283\":\",\",\"284\":\"\\\"\",\"285\":\"3\",\"286\":\"2\",\"287\":\"\\\"\",\"288\":\":\",\"289\":\"\\\"\",\"290\":\"l\",\"291\":\"\\\"\",\"292\":\",\",\"293\":\"\\\"\",\"294\":\"3\",\"295\":\"3\",\"296\":\"\\\"\",\"297\":\":\",\"298\":\"\\\"\",\"299\":\"e\",\"300\":\"\\\"\",\"301\":\",\",\"302\":\"\\\"\",\"303\":\"3\",\"304\":\"4\",\"305\":\"\\\"\",\"306\":\":\",\"307\":\"\\\"\",\"308\":\"\\\\\",\"309\":\"\\\"\",\"310\":\"\\\"\",\"311\":\",\",\"312\":\"\\\"\",\"313\":\"3\",\"314\":\"5\",\"315\":\"\\\"\",\"316\":\":\",\"317\":\"\\\"\",\"318\":\":\",\"319\":\"\\\"\",\"320\":\",\",\"321\":\"\\\"\",\"322\":\"3\",\"323\":\"6\",\"324\":\"\\\"\",\"325\":\":\",\"326\":\"\\\"\",\"327\":\"\\\\\",\"328\":\"\\\"\",\"329\":\"\\\"\",\"330\":\",\",\"331\":\"\\\"\",\"332\":\"3\",\"333\":\"7\",\"334\":\"\\\"\",\"335\":\":\",\"336\":\"\\\"\",\"337\":\"e\",\"338\":\"\\\"\",\"339\":\",\",\"340\":\"\\\"\",\"341\":\"3\",\"342\":\"8\",\"343\":\"\\\"\",\"344\":\":\",\"345\":\"\\\"\",\"346\":\"n\",\"347\":\"\\\"\",\"348\":\",\",\"349\":\"\\\"\",\"350\":\"3\",\"351\":\"9\",\"352\":\"\\\"\",\"353\":\":\",\"354\":\"\\\"\",\"355\":\"-\",\"356\":\"\\\"\",\"357\":\",\",\"358\":\"\\\"\",\"359\":\"4\",\"360\":\"0\",\"361\":\"\\\"\",\"362\":\":\",\"363\":\"\\\"\",\"364\":\"I\",\"365\":\"\\\"\",\"366\":\",\",\"367\":\"\\\"\",\"368\":\"4\",\"369\":\"1\",\"370\":\"\\\"\",\"371\":\":\",\"372\":\"\\\"\",\"373\":\"N\",\"374\":\"\\\"\",\"375\":\",\",\"376\":\"\\\"\",\"377\":\"4\",\"378\":\"2\",\"379\":\"\\\"\",\"380\":\":\",\"381\":\"\\\"\",\"382\":\"\\\\\",\"383\":\"\\\"\",\"384\":\"\\\"\",\"385\":\",\",\"386\":\"\\\"\",\"387\":\"4\",\"388\":\"3\",\"389\":\"\\\"\",\"390\":\":\",\"391\":\"\\\"\",\"392\":\"}\",\"393\":\"\\\"\",\"394\":\",\",\"395\":\"\\\"\",\"396\":\"w\",\"397\":\"i\",\"398\":\"d\",\"399\":\"g\",\"400\":\"e\",\"401\":\"t\",\"402\":\"C\",\"403\":\"h\",\"404\":\"a\",\"405\":\"n\",\"406\":\"n\",\"407\":\"e\",\"408\":\"l\",\"409\":\"I\",\"410\":\"d\",\"411\":\"\\\"\",\"412\":\":\",\"413\":\"\\\"\",\"414\":\"8\",\"415\":\"6\",\"416\":\"7\",\"417\":\"f\",\"418\":\"3\",\"419\":\"6\",\"420\":\"e\",\"421\":\"8\",\"422\":\"-\",\"423\":\"1\",\"424\":\"0\",\"425\":\"5\",\"426\":\"5\",\"427\":\"-\",\"428\":\"4\",\"429\":\"6\",\"430\":\"8\",\"431\":\"5\",\"432\":\"-\",\"433\":\"9\",\"434\":\"a\",\"435\":\"2\",\"436\":\"d\",\"437\":\"-\",\"438\":\"6\",\"439\":\"2\",\"440\":\"f\",\"441\":\"b\",\"442\":\"4\",\"443\":\"1\",\"444\":\"0\",\"445\":\"d\",\"446\":\"4\",\"447\":\"b\",\"448\":\"0\",\"449\":\"5\",\"450\":\"\\\"\",\"451\":\"}\",\"widgetChannelId\":\"867f36e8-1055-4685-9a2d-62fb410d4b05\"}}', '2026-10-22 08:21:15.646'),
('1b682b7e-d330-45fa-a22d-99609c01c579', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'flows.create', 'flow', '863c7b68-700e-4430-8de0-7919e82d40b0', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"Smoke test flow\",\"triggerType\":\"message.received\"}', '2026-10-20 10:13:20.535'),
('1e2d649d-387f-4df4-9eb0-afd9604fefbd', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.publish', 'agent', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'success', '::ffff:127.0.0.1', NULL, '{\"version\":1}', '2026-10-20 11:56:14.324'),
('1ea0270b-3282-45ce-a2fd-35bd3cb36511', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-24 14:55:32.216'),
('2537b940-8eff-44df-9ab0-e2677fed89f3', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-31 16:44:15.489'),
('2a030065-9686-4a98-bdc5-76c697fb12f6', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.delete', 'campaign', '0e94f491-bbf8-47be-995a-fa76dfaa7a33', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"Test campaign\",\"status\":\"cancelled\"}', '2026-10-24 15:13:49.161'),
('2b96003d-c730-4c5b-bf4d-8f006bcf14a2', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.tools_update', 'agent', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'success', '::ffff:127.0.0.1', NULL, '{\"count\":1}', '2026-10-20 11:53:47.551'),
('2d9160fa-2c5b-4636-bef8-49522f10c2b8', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'templates.delete', 'template', '06920ea3-68a6-4168-ac82-4eabe50b32eb', 'success', '::1', NULL, '{\"name\":\"Greeting\"}', '2026-10-24 14:42:19.857'),
('2e46ea34-628e-4d72-85bd-0ed4e4bf5628', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'auth.login', 'user', '59627376-d414-4b33-a8c5-756cf5d231a1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '{}', '2026-10-20 11:31:30.262'),
('304f4b7d-7cd2-4d37-bca3-139f7b411640', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'auth.login', 'user', '59627376-d414-4b33-a8c5-756cf5d231a1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '{}', '2026-10-20 10:00:31.286'),
('324a7e37-e764-494c-bbff-4894e44a7f3c', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'flows.delete', 'flow', '863c7b68-700e-4430-8de0-7919e82d40b0', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"Smoke test flow\"}', '2026-10-20 10:13:20.595'),
('34b8886f-3441-48bc-8ca5-26c5f1720f7b', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-22 10:41:36.723'),
('360bfa1a-056d-4efe-b77e-d4f3be17be96', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.playground', 'agent', '0d72efde-f505-4f96-ac6d-e04235842656', 'success', '::ffff:127.0.0.1', NULL, '{\"escalated\":false,\"iterations\":1}', '2026-10-29 11:31:34.063'),
('391be716-93db-4a53-a94d-ef8e5a7e14af', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-22 11:15:05.880'),
('3a21e9fa-c2db-4aca-b608-564d2475fde5', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'auth.login', 'user', '59627376-d414-4b33-a8c5-756cf5d231a1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '{}', '2026-10-21 16:29:20.731'),
('3a2708cc-94b2-454a-812f-1077d378d0b7', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.create', 'agent', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"sales agent\",\"type\":\"sales\"}', '2026-10-20 10:01:02.982'),
('3bdae540-6d5d-4255-a106-2b3a77125864', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-31 16:46:05.505'),
('3cb0cf06-63f7-4ff1-9561-72d12e51eb70', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'channels.create', 'channel', '048c105a-3177-4c66-b5ef-32fe95eba2f9', 'success', '::1', NULL, '{\"type\":\"telegram\",\"name\":\"Telegram - avpsofttechbot\"}', '2026-10-31 16:41:44.388'),
('3df41136-9fbf-42f0-b0b8-62f77a13dd0d', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.create', 'campaign', '0e94f491-bbf8-47be-995a-fa76dfaa7a33', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"Test campaign\",\"channelType\":\"whatsapp\",\"audienceMode\":\"all\",\"matched\":2,\"deliverable\":1,\"suppressed\":1}', '2026-10-24 15:13:49.108'),
('42252c3a-fb5f-4fd8-8e08-34522d447b91', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-24 14:41:56.453'),
('438e20a9-ab84-48f9-9df1-d953e2b253d0', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.publish', 'agent', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'success', '::ffff:127.0.0.1', NULL, '{\"version\":1}', '2026-10-20 11:32:29.516'),
('45f3cf92-7996-437f-8688-660d7f1f83e6', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.create', 'channel', '2b9aca35-07e7-4fce-844f-74bcf136a405', 'success', '::ffff:127.0.0.1', NULL, '{\"type\":\"discord\",\"name\":\"dd\"}', '2026-10-31 17:58:32.779'),
('468178ea-3f54-4770-9cfb-0f69e8b084df', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.playground', 'agent', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'success', '::ffff:127.0.0.1', NULL, '{\"escalated\":false,\"iterations\":2}', '2026-10-29 12:10:52.160'),
('468ef79f-0d64-40e5-8677-b2ffebc5ddb5', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.create', 'channel', 'bb543c06-1355-401b-9d52-933b78edf544', 'success', '::ffff:127.0.0.1', NULL, '{\"type\":\"telegram\",\"name\":\"tesr\"}', '2026-10-30 16:33:03.863'),
('47523584-f422-4900-bddb-6ce382742b0c', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-22 05:59:13.512'),
('47e589ce-5695-43f4-aed2-acc5cba9937a', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-20 10:18:41.541'),
('484571a3-9182-49ee-be83-dccf5db8307b', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.tools_update', 'agent', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'success', '::ffff:127.0.0.1', NULL, '{\"count\":2}', '2026-10-20 11:53:59.557'),
('4c8df8ce-d9ef-47b1-be5d-18a14954ca3b', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.recipients.add', 'campaign', '4e0f088a-2775-4339-80fb-cc7c4f049529', 'success', '::1', NULL, '{\"added\":1,\"suppressed\":0}', '2026-10-24 14:55:56.661'),
('4cb5943a-cba3-40ae-b66c-d34cbddb6fc7', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.create', 'campaign', 'eea185ab-60f9-4421-9269-04a2dfcb05b0', 'success', '::1', NULL, '{\"name\":\"Test broadcast\",\"channelType\":\"whatsapp\"}', '2026-10-24 14:55:32.290'),
('4cd4eb3b-65c1-4195-959e-bb7706dc0240', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'auth.login', 'user', '59627376-d414-4b33-a8c5-756cf5d231a1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '{}', '2026-10-29 11:02:05.457'),
('4f47c3e1-7ed6-4493-acdb-729f373de6de', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.playground', 'agent', '0d72efde-f505-4f96-ac6d-e04235842656', 'success', '::ffff:127.0.0.1', NULL, '{\"escalated\":false,\"iterations\":1}', '2026-10-29 11:50:19.774'),
('50e53b82-0fd7-4b36-882c-51e81ee511ee', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.create', 'channel', 'a974ac21-61f4-476f-83c7-3bb797bfe758', 'success', '::ffff:127.0.0.1', NULL, '{\"type\":\"telegram\",\"name\":\"telegram\"}', '2026-10-29 14:39:07.878'),
('51927faf-4ba8-41ed-90eb-cb11b689b54d', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.create', 'agent', 'f803b4a0-5da6-4912-ba1d-4a8fb2af9638', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"HR AGENT\",\"type\":\"hr\"}', '2026-10-29 12:14:31.591'),
('5517b858-540b-4f38-9ed2-602fd9ad3eab', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.publish', 'agent', 'f803b4a0-5da6-4912-ba1d-4a8fb2af9638', 'success', '::ffff:127.0.0.1', NULL, '{\"version\":1}', '2026-10-29 14:13:21.735');
INSERT INTO `audit_events` (`id`, `workspace_id`, `actor_user_id`, `actor_type`, `action`, `resource_type`, `resource_id`, `outcome`, `ip`, `user_agent`, `metadata`, `created_at`) VALUES
('56f778c7-ecc7-4bda-97bf-2898c1595515', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'workspace.update', 'workspace', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'success', '::ffff:127.0.0.1', NULL, '{\"settings\":{\"0\":\"{\",\"1\":\"\\\"\",\"2\":\"0\",\"3\":\"\\\"\",\"4\":\":\",\"5\":\"\\\"\",\"6\":\"{\",\"7\":\"\\\"\",\"8\":\",\",\"9\":\"\\\"\",\"10\":\"1\",\"11\":\"\\\"\",\"12\":\":\",\"13\":\"\\\"\",\"14\":\"\\\\\",\"15\":\"\\\"\",\"16\":\"\\\"\",\"17\":\",\",\"18\":\"\\\"\",\"19\":\"2\",\"20\":\"\\\"\",\"21\":\":\",\"22\":\"\\\"\",\"23\":\"0\",\"24\":\"\\\"\",\"25\":\",\",\"26\":\"\\\"\",\"27\":\"3\",\"28\":\"\\\"\",\"29\":\":\",\"30\":\"\\\"\",\"31\":\"\\\\\",\"32\":\"\\\"\",\"33\":\"\\\"\",\"34\":\",\",\"35\":\"\\\"\",\"36\":\"4\",\"37\":\"\\\"\",\"38\":\":\",\"39\":\"\\\"\",\"40\":\":\",\"41\":\"\\\"\",\"42\":\",\",\"43\":\"\\\"\",\"44\":\"5\",\"45\":\"\\\"\",\"46\":\":\",\"47\":\"\\\"\",\"48\":\"\\\\\",\"49\":\"\\\"\",\"50\":\"\\\"\",\"51\":\",\",\"52\":\"\\\"\",\"53\":\"6\",\"54\":\"\\\"\",\"55\":\":\",\"56\":\"\\\"\",\"57\":\"{\",\"58\":\"\\\"\",\"59\":\",\",\"60\":\"\\\"\",\"61\":\"7\",\"62\":\"\\\"\",\"63\":\":\",\"64\":\"\\\"\",\"65\":\"\\\\\",\"66\":\"\\\"\",\"67\":\"\\\"\",\"68\":\",\",\"69\":\"\\\"\",\"70\":\"8\",\"71\":\"\\\"\",\"72\":\":\",\"73\":\"\\\"\",\"74\":\",\",\"75\":\"\\\"\",\"76\":\",\",\"77\":\"\\\"\",\"78\":\"9\",\"79\":\"\\\"\",\"80\":\":\",\"81\":\"\\\"\",\"82\":\"\\\\\",\"83\":\"\\\"\",\"84\":\"\\\"\",\"85\":\",\",\"86\":\"\\\"\",\"87\":\"1\",\"88\":\"0\",\"89\":\"\\\"\",\"90\":\":\",\"91\":\"\\\"\",\"92\":\"1\",\"93\":\"\\\"\",\"94\":\",\",\"95\":\"\\\"\",\"96\":\"1\",\"97\":\"1\",\"98\":\"\\\"\",\"99\":\":\",\"100\":\"\\\"\",\"101\":\"\\\\\",\"102\":\"\\\"\",\"103\":\"\\\"\",\"104\":\",\",\"105\":\"\\\"\",\"106\":\"1\",\"107\":\"2\",\"108\":\"\\\"\",\"109\":\":\",\"110\":\"\\\"\",\"111\":\":\",\"112\":\"\\\"\",\"113\":\",\",\"114\":\"\\\"\",\"115\":\"1\",\"116\":\"3\",\"117\":\"\\\"\",\"118\":\":\",\"119\":\"\\\"\",\"120\":\"\\\\\",\"121\":\"\\\"\",\"122\":\"\\\"\",\"123\":\",\",\"124\":\"\\\"\",\"125\":\"1\",\"126\":\"4\",\"127\":\"\\\"\",\"128\":\":\",\"129\":\"\\\"\",\"130\":\"\\\\\",\"131\":\"\\\\\",\"132\":\"\\\"\",\"133\":\",\",\"134\":\"\\\"\",\"135\":\"1\",\"136\":\"5\",\"137\":\"\\\"\",\"138\":\":\",\"139\":\"\\\"\",\"140\":\"\\\\\",\"141\":\"\\\"\",\"142\":\"\\\"\",\"143\":\",\",\"144\":\"\\\"\",\"145\":\"1\",\"146\":\"6\",\"147\":\"\\\"\",\"148\":\":\",\"149\":\"\\\"\",\"150\":\"\\\\\",\"151\":\"\\\"\",\"152\":\"\\\"\",\"153\":\",\",\"154\":\"\\\"\",\"155\":\"1\",\"156\":\"7\",\"157\":\"\\\"\",\"158\":\":\",\"159\":\"\\\"\",\"160\":\",\",\"161\":\"\\\"\",\"162\":\",\",\"163\":\"\\\"\",\"164\":\"1\",\"165\":\"8\",\"166\":\"\\\"\",\"167\":\":\",\"168\":\"\\\"\",\"169\":\"\\\\\",\"170\":\"\\\"\",\"171\":\"\\\"\",\"172\":\",\",\"173\":\"\\\"\",\"174\":\"1\",\"175\":\"9\",\"176\":\"\\\"\",\"177\":\":\",\"178\":\"\\\"\",\"179\":\"2\",\"180\":\"\\\"\",\"181\":\",\",\"182\":\"\\\"\",\"183\":\"2\",\"184\":\"0\",\"185\":\"\\\"\",\"186\":\":\",\"187\":\"\\\"\",\"188\":\"\\\\\",\"189\":\"\\\"\",\"190\":\"\\\"\",\"191\":\",\",\"192\":\"\\\"\",\"193\":\"2\",\"194\":\"1\",\"195\":\"\\\"\",\"196\":\":\",\"197\":\"\\\"\",\"198\":\":\",\"199\":\"\\\"\",\"200\":\",\",\"201\":\"\\\"\",\"202\":\"2\",\"203\":\"2\",\"204\":\"\\\"\",\"205\":\":\",\"206\":\"\\\"\",\"207\":\"\\\\\",\"208\":\"\\\"\",\"209\":\"\\\"\",\"210\":\",\",\"211\":\"\\\"\",\"212\":\"2\",\"213\":\"3\",\"214\":\"\\\"\",\"215\":\":\",\"216\":\"\\\"\",\"217\":\"t\",\"218\":\"\\\"\",\"219\":\",\",\"220\":\"\\\"\",\"221\":\"2\",\"222\":\"4\",\"223\":\"\\\"\",\"224\":\":\",\"225\":\"\\\"\",\"226\":\"\\\\\",\"227\":\"\\\"\",\"228\":\"\\\"\",\"229\":\",\",\"230\":\"\\\"\",\"231\":\"2\",\"232\":\"5\",\"233\":\"\\\"\",\"234\":\":\",\"235\":\"\\\"\",\"236\":\",\",\"237\":\"\\\"\",\"238\":\",\",\"239\":\"\\\"\",\"240\":\"2\",\"241\":\"6\",\"242\":\"\\\"\",\"243\":\":\",\"244\":\"\\\"\",\"245\":\"\\\\\",\"246\":\"\\\"\",\"247\":\"\\\"\",\"248\":\",\",\"249\":\"\\\"\",\"250\":\"2\",\"251\":\"7\",\"252\":\"\\\"\",\"253\":\":\",\"254\":\"\\\"\",\"255\":\"3\",\"256\":\"\\\"\",\"257\":\",\",\"258\":\"\\\"\",\"259\":\"2\",\"260\":\"8\",\"261\":\"\\\"\",\"262\":\":\",\"263\":\"\\\"\",\"264\":\"\\\\\",\"265\":\"\\\"\",\"266\":\"\\\"\",\"267\":\",\",\"268\":\"\\\"\",\"269\":\"2\",\"270\":\"9\",\"271\":\"\\\"\",\"272\":\":\",\"273\":\"\\\"\",\"274\":\":\",\"275\":\"\\\"\",\"276\":\",\",\"277\":\"\\\"\",\"278\":\"3\",\"279\":\"0\",\"280\":\"\\\"\",\"281\":\":\",\"282\":\"\\\"\",\"283\":\"\\\\\",\"284\":\"\\\"\",\"285\":\"\\\"\",\"286\":\",\",\"287\":\"\\\"\",\"288\":\"3\",\"289\":\"1\",\"290\":\"\\\"\",\"291\":\":\",\"292\":\"\\\"\",\"293\":\"i\",\"294\":\"\\\"\",\"295\":\",\",\"296\":\"\\\"\",\"297\":\"3\",\"298\":\"2\",\"299\":\"\\\"\",\"300\":\":\",\"301\":\"\\\"\",\"302\":\"\\\\\",\"303\":\"\\\"\",\"304\":\"\\\"\",\"305\":\",\",\"306\":\"\\\"\",\"307\":\"3\",\"308\":\"3\",\"309\":\"\\\"\",\"310\":\":\",\"311\":\"\\\"\",\"312\":\",\",\"313\":\"\\\"\",\"314\":\",\",\"315\":\"\\\"\",\"316\":\"3\",\"317\":\"4\",\"318\":\"\\\"\",\"319\":\":\",\"320\":\"\\\"\",\"321\":\"\\\\\",\"322\":\"\\\"\",\"323\":\"\\\"\",\"324\":\",\",\"325\":\"\\\"\",\"326\":\"3\",\"327\":\"5\",\"328\":\"\\\"\",\"329\":\":\",\"330\":\"\\\"\",\"331\":\"4\",\"332\":\"\\\"\",\"333\":\",\",\"334\":\"\\\"\",\"335\":\"3\",\"336\":\"6\",\"337\":\"\\\"\",\"338\":\":\",\"339\":\"\\\"\",\"340\":\"\\\\\",\"341\":\"\\\"\",\"342\":\"\\\"\",\"343\":\",\",\"344\":\"\\\"\",\"345\":\"3\",\"346\":\"7\",\"347\":\"\\\"\",\"348\":\":\",\"349\":\"\\\"\",\"350\":\":\",\"351\":\"\\\"\",\"352\":\",\",\"353\":\"\\\"\",\"354\":\"3\",\"355\":\"8\",\"356\":\"\\\"\",\"357\":\":\",\"358\":\"\\\"\",\"359\":\"\\\\\",\"360\":\"\\\"\",\"361\":\"\\\"\",\"362\":\",\",\"363\":\"\\\"\",\"364\":\"3\",\"365\":\"9\",\"366\":\"\\\"\",\"367\":\":\",\"368\":\"\\\"\",\"369\":\"m\",\"370\":\"\\\"\",\"371\":\",\",\"372\":\"\\\"\",\"373\":\"4\",\"374\":\"0\",\"375\":\"\\\"\",\"376\":\":\",\"377\":\"\\\"\",\"378\":\"\\\\\",\"379\":\"\\\"\",\"380\":\"\\\"\",\"381\":\",\",\"382\":\"\\\"\",\"383\":\"4\",\"384\":\"1\",\"385\":\"\\\"\",\"386\":\":\",\"387\":\"\\\"\",\"388\":\",\",\"389\":\"\\\"\",\"390\":\",\",\"391\":\"\\\"\",\"392\":\"4\",\"393\":\"2\",\"394\":\"\\\"\",\"395\":\":\",\"396\":\"\\\"\",\"397\":\"\\\\\",\"398\":\"\\\"\",\"399\":\"\\\"\",\"400\":\",\",\"401\":\"\\\"\",\"402\":\"4\",\"403\":\"3\",\"404\":\"\\\"\",\"405\":\":\",\"406\":\"\\\"\",\"407\":\"5\",\"408\":\"\\\"\",\"409\":\",\",\"410\":\"\\\"\",\"411\":\"4\",\"412\":\"4\",\"413\":\"\\\"\",\"414\":\":\",\"415\":\"\\\"\",\"416\":\"\\\\\",\"417\":\"\\\"\",\"418\":\"\\\"\",\"419\":\",\",\"420\":\"\\\"\",\"421\":\"4\",\"422\":\"5\",\"423\":\"\\\"\",\"424\":\":\",\"425\":\"\\\"\",\"426\":\":\",\"427\":\"\\\"\",\"428\":\",\",\"429\":\"\\\"\",\"430\":\"4\",\"431\":\"6\",\"432\":\"\\\"\",\"433\":\":\",\"434\":\"\\\"\",\"435\":\"\\\\\",\"436\":\"\\\"\",\"437\":\"\\\"\",\"438\":\",\",\"439\":\"\\\"\",\"440\":\"4\",\"441\":\"7\",\"442\":\"\\\"\",\"443\":\":\",\"444\":\"\\\"\",\"445\":\"e\",\"446\":\"\\\"\",\"447\":\",\",\"448\":\"\\\"\",\"449\":\"4\",\"450\":\"8\",\"451\":\"\\\"\",\"452\":\":\",\"453\":\"\\\"\",\"454\":\"\\\\\",\"455\":\"\\\"\",\"456\":\"\\\"\",\"457\":\",\",\"458\":\"\\\"\",\"459\":\"4\",\"460\":\"9\",\"461\":\"\\\"\",\"462\":\":\",\"463\":\"\\\"\",\"464\":\",\",\"465\":\"\\\"\",\"466\":\",\",\"467\":\"\\\"\",\"468\":\"5\",\"469\":\"0\",\"470\":\"\\\"\",\"471\":\":\",\"472\":\"\\\"\",\"473\":\"\\\\\",\"474\":\"\\\"\",\"475\":\"\\\"\",\"476\":\",\",\"477\":\"\\\"\",\"478\":\"5\",\"479\":\"1\",\"480\":\"\\\"\",\"481\":\":\",\"482\":\"\\\"\",\"483\":\"6\",\"484\":\"\\\"\",\"485\":\",\",\"486\":\"\\\"\",\"487\":\"5\",\"488\":\"2\",\"489\":\"\\\"\",\"490\":\":\",\"491\":\"\\\"\",\"492\":\"\\\\\",\"493\":\"\\\"\",\"494\":\"\\\"\",\"495\":\",\",\"496\":\"\\\"\",\"497\":\"5\",\"498\":\"3\",\"499\":\"\\\"\",\"500\":\":\",\"501\":\"\\\"\",\"502\":\":\",\"503\":\"\\\"\",\"504\":\",\",\"505\":\"\\\"\",\"506\":\"5\",\"507\":\"4\",\"508\":\"\\\"\",\"509\":\":\",\"510\":\"\\\"\",\"511\":\"\\\\\",\"512\":\"\\\"\",\"513\":\"\\\"\",\"514\":\",\",\"515\":\"\\\"\",\"516\":\"5\",\"517\":\"5\",\"518\":\"\\\"\",\"519\":\":\",\"520\":\"\\\"\",\"521\":\"z\",\"522\":\"\\\"\",\"523\":\",\",\"524\":\"\\\"\",\"525\":\"5\",\"526\":\"6\",\"527\":\"\\\"\",\"528\":\":\",\"529\":\"\\\"\",\"530\":\"\\\\\",\"531\":\"\\\"\",\"532\":\"\\\"\",\"533\":\",\",\"534\":\"\\\"\",\"535\":\"5\",\"536\":\"7\",\"537\":\"\\\"\",\"538\":\":\",\"539\":\"\\\"\",\"540\":\",\",\"541\":\"\\\"\",\"542\":\",\",\"543\":\"\\\"\",\"544\":\"5\",\"545\":\"8\",\"546\":\"\\\"\",\"547\":\":\",\"548\":\"\\\"\",\"549\":\"\\\\\",\"550\":\"\\\"\",\"551\":\"\\\"\",\"552\":\",\",\"553\":\"\\\"\",\"554\":\"5\",\"555\":\"9\",\"556\":\"\\\"\",\"557\":\":\",\"558\":\"\\\"\",\"559\":\"7\",\"560\":\"\\\"\",\"561\":\",\",\"562\":\"\\\"\",\"563\":\"6\",\"564\":\"0\",\"565\":\"\\\"\",\"566\":\":\",\"567\":\"\\\"\",\"568\":\"\\\\\",\"569\":\"\\\"\",\"570\":\"\\\"\",\"571\":\",\",\"572\":\"\\\"\",\"573\":\"6\",\"574\":\"1\",\"575\":\"\\\"\",\"576\":\":\",\"577\":\"\\\"\",\"578\":\":\",\"579\":\"\\\"\",\"580\":\",\",\"581\":\"\\\"\",\"582\":\"6\",\"583\":\"2\",\"584\":\"\\\"\",\"585\":\":\",\"586\":\"\\\"\",\"587\":\"\\\\\",\"588\":\"\\\"\",\"589\":\"\\\"\",\"590\":\",\",\"591\":\"\\\"\",\"592\":\"6\",\"593\":\"3\",\"594\":\"\\\"\",\"595\":\":\",\"596\":\"\\\"\",\"597\":\"o\",\"598\":\"\\\"\",\"599\":\",\",\"600\":\"\\\"\",\"601\":\"6\",\"602\":\"4\",\"603\":\"\\\"\",\"604\":\":\",\"605\":\"\\\"\",\"606\":\"\\\\\",\"607\":\"\\\"\",\"608\":\"\\\"\",\"609\":\",\",\"610\":\"\\\"\",\"611\":\"6\",\"612\":\"5\",\"613\":\"\\\"\",\"614\":\":\",\"615\":\"\\\"\",\"616\":\",\",\"617\":\"\\\"\",\"618\":\",\",\"619\":\"\\\"\",\"620\":\"6\",\"621\":\"6\",\"622\":\"\\\"\",\"623\":\":\",\"624\":\"\\\"\",\"625\":\"\\\\\",\"626\":\"\\\"\",\"627\":\"\\\"\",\"628\":\",\",\"629\":\"\\\"\",\"630\":\"6\",\"631\":\"7\",\"632\":\"\\\"\",\"633\":\":\",\"634\":\"\\\"\",\"635\":\"8\",\"636\":\"\\\"\",\"637\":\",\",\"638\":\"\\\"\",\"639\":\"6\",\"640\":\"8\",\"641\":\"\\\"\",\"642\":\":\",\"643\":\"\\\"\",\"644\":\"\\\\\",\"645\":\"\\\"\",\"646\":\"\\\"\",\"647\":\",\",\"648\":\"\\\"\",\"649\":\"6\",\"650\":\"9\",\"651\":\"\\\"\",\"652\":\":\",\"653\":\"\\\"\",\"654\":\":\",\"655\":\"\\\"\",\"656\":\",\",\"657\":\"\\\"\",\"658\":\"7\",\"659\":\"0\",\"660\":\"\\\"\",\"661\":\":\",\"662\":\"\\\"\",\"663\":\"\\\\\",\"664\":\"\\\"\",\"665\":\"\\\"\",\"666\":\",\",\"667\":\"\\\"\",\"668\":\"7\",\"669\":\"1\",\"670\":\"\\\"\",\"671\":\":\",\"672\":\"\\\"\",\"673\":\"n\",\"674\":\"\\\"\",\"675\":\",\",\"676\":\"\\\"\",\"677\":\"7\",\"678\":\"2\",\"679\":\"\\\"\",\"680\":\":\",\"681\":\"\\\"\",\"682\":\"\\\\\",\"683\":\"\\\"\",\"684\":\"\\\"\",\"685\":\",\",\"686\":\"\\\"\",\"687\":\"7\",\"688\":\"3\",\"689\":\"\\\"\",\"690\":\":\",\"691\":\"\\\"\",\"692\":\",\",\"693\":\"\\\"\",\"694\":\",\",\"695\":\"\\\"\",\"696\":\"7\",\"697\":\"4\",\"698\":\"\\\"\",\"699\":\":\",\"700\":\"\\\"\",\"701\":\"\\\\\",\"702\":\"\\\"\",\"703\":\"\\\"\",\"704\":\",\",\"705\":\"\\\"\",\"706\":\"7\",\"707\":\"5\",\"708\":\"\\\"\",\"709\":\":\",\"710\":\"\\\"\",\"711\":\"9\",\"712\":\"\\\"\",\"713\":\",\",\"714\":\"\\\"\",\"715\":\"7\",\"716\":\"6\",\"717\":\"\\\"\",\"718\":\":\",\"719\":\"\\\"\",\"720\":\"\\\\\",\"721\":\"\\\"\",\"722\":\"\\\"\",\"723\":\",\",\"724\":\"\\\"\",\"725\":\"7\",\"726\":\"7\",\"727\":\"\\\"\",\"728\":\":\",\"729\":\"\\\"\",\"730\":\":\",\"731\":\"\\\"\",\"732\":\",\",\"733\":\"\\\"\",\"734\":\"7\",\"735\":\"8\",\"736\":\"\\\"\",\"737\":\":\",\"738\":\"\\\"\",\"739\":\"\\\\\",\"740\":\"\\\"\",\"741\":\"\\\"\",\"742\":\",\",\"743\":\"\\\"\",\"744\":\"7\",\"745\":\"9\",\"746\":\"\\\"\",\"747\":\":\",\"748\":\"\\\"\",\"749\":\"e\",\"750\":\"\\\"\",\"751\":\",\",\"752\":\"\\\"\",\"753\":\"8\",\"754\":\"0\",\"755\":\"\\\"\",\"756\":\":\",\"757\":\"\\\"\",\"758\":\"\\\\\",\"759\":\"\\\"\",\"760\":\"\\\"\",\"761\":\",\",\"762\":\"\\\"\",\"763\":\"8\",\"764\":\"1\",\"765\":\"\\\"\",\"766\":\":\",\"767\":\"\\\"\",\"768\":\",\",\"769\":\"\\\"\",\"770\":\",\",\"771\":\"\\\"\",\"772\":\"8\",\"773\":\"2\",\"774\":\"\\\"\",\"775\":\":\",\"776\":\"\\\"\",\"777\":\"\\\\\",\"778\":\"\\\"\",\"779\":\"\\\"\",\"780\":\",\",\"781\":\"\\\"\",\"782\":\"8\",\"783\":\"3\",\"784\":\"\\\"\",\"785\":\":\",\"786\":\"\\\"\",\"787\":\"1\",\"788\":\"\\\"\",\"789\":\",\",\"790\":\"\\\"\",\"791\":\"8\",\"792\":\"4\",\"793\":\"\\\"\",\"794\":\":\",\"795\":\"\\\"\",\"796\":\"0\",\"797\":\"\\\"\",\"798\":\",\",\"799\":\"\\\"\",\"800\":\"8\",\"801\":\"5\",\"802\":\"\\\"\",\"803\":\":\",\"804\":\"\\\"\",\"805\":\"\\\\\",\"806\":\"\\\"\",\"807\":\"\\\"\",\"808\":\",\",\"809\":\"\\\"\",\"810\":\"8\",\"811\":\"6\",\"812\":\"\\\"\",\"813\":\":\",\"814\":\"\\\"\",\"815\":\":\",\"816\":\"\\\"\",\"817\":\",\",\"818\":\"\\\"\",\"819\":\"8\",\"820\":\"7\",\"821\":\"\\\"\",\"822\":\":\",\"823\":\"\\\"\",\"824\":\"\\\\\",\"825\":\"\\\"\",\"826\":\"\\\"\",\"827\":\",\",\"828\":\"\\\"\",\"829\":\"8\",\"830\":\"8\",\"831\":\"\\\"\",\"832\":\":\",\"833\":\"\\\"\",\"834\":\"\\\\\",\"835\":\"\\\\\",\"836\":\"\\\"\",\"837\":\",\",\"838\":\"\\\"\",\"839\":\"8\",\"840\":\"9\",\"841\":\"\\\"\",\"842\":\":\",\"843\":\"\\\"\",\"844\":\"\\\\\",\"845\":\"\\\"\",\"846\":\"\\\"\",\"847\":\",\",\"848\":\"\\\"\",\"849\":\"9\",\"850\":\"0\",\"851\":\"\\\"\",\"852\":\":\",\"853\":\"\\\"\",\"854\":\"\\\\\",\"855\":\"\\\"\",\"856\":\"\\\"\",\"857\":\",\",\"858\":\"\\\"\",\"859\":\"9\",\"860\":\"1\",\"861\":\"\\\"\",\"862\":\":\",\"863\":\"\\\"\",\"864\":\",\",\"865\":\"\\\"\",\"866\":\",\",\"867\":\"\\\"\",\"868\":\"9\",\"869\":\"2\",\"870\":\"\\\"\",\"871\":\":\",\"872\":\"\\\"\",\"873\":\"\\\\\",\"874\":\"\\\"\",\"875\":\"\\\"\",\"876\":\",\",\"877\":\"\\\"\",\"878\":\"9\",\"879\":\"3\",\"880\":\"\\\"\",\"881\":\":\",\"882\":\"\\\"\",\"883\":\"1\",\"884\":\"\\\"\",\"885\":\",\",\"886\":\"\\\"\",\"887\":\"9\",\"888\":\"4\",\"889\":\"\\\"\",\"890\":\":\",\"891\":\"\\\"\",\"892\":\"1\",\"893\":\"\\\"\",\"894\":\",\",\"895\":\"\\\"\",\"896\":\"9\",\"897\":\"5\",\"898\":\"\\\"\",\"899\":\":\",\"900\":\"\\\"\",\"901\":\"\\\\\",\"902\":\"\\\"\",\"903\":\"\\\"\",\"904\":\",\",\"905\":\"\\\"\",\"906\":\"9\",\"907\":\"6\",\"908\":\"\\\"\",\"909\":\":\",\"910\":\"\\\"\",\"911\":\":\",\"912\":\"\\\"\",\"913\":\",\",\"914\":\"\\\"\",\"915\":\"9\",\"916\":\"7\",\"917\":\"\\\"\",\"918\":\":\",\"919\":\"\\\"\",\"920\":\"\\\\\",\"921\":\"\\\"\",\"922\":\"\\\"\",\"923\":\",\",\"924\":\"\\\"\",\"925\":\"9\",\"926\":\"8\",\"927\":\"\\\"\",\"928\":\":\",\"929\":\"\\\"\",\"930\":\":\",\"931\":\"\\\"\",\"932\":\",\",\"933\":\"\\\"\",\"934\":\"9\",\"935\":\"9\",\"936\":\"\\\"\",\"937\":\":\",\"938\":\"\\\"\",\"939\":\"\\\\\",\"940\":\"\\\"\",\"941\":\"\\\"\",\"942\":\",\",\"943\":\"\\\"\",\"944\":\"1\",\"945\":\"0\",\"946\":\"0\",\"947\":\"\\\"\",\"948\":\":\",\"949\":\"\\\"\",\"950\":\",\",\"951\":\"\\\"\",\"952\":\",\",\"953\":\"\\\"\",\"954\":\"1\",\"955\":\"0\",\"956\":\"1\",\"957\":\"\\\"\",\"958\":\":\",\"959\":\"\\\"\",\"960\":\"\\\\\",\"961\":\"\\\"\",\"962\":\"\\\"\",\"963\":\",\",\"964\":\"\\\"\",\"965\":\"1\",\"966\":\"0\",\"967\":\"2\",\"968\":\"\\\"\",\"969\":\":\",\"970\":\"\\\"\",\"971\":\"1\",\"972\":\"\\\"\",\"973\":\",\",\"974\":\"\\\"\",\"975\":\"1\",\"976\":\"0\",\"977\":\"3\",\"978\":\"\\\"\",\"979\":\":\",\"980\":\"\\\"\",\"981\":\"2\",\"982\":\"\\\"\",\"983\":\",\",\"984\":\"\\\"\",\"985\":\"1\",\"986\":\"0\",\"987\":\"4\",\"988\":\"\\\"\",\"989\":\":\",\"990\":\"\\\"\",\"991\":\"\\\\\",\"992\":\"\\\"\",\"993\":\"\\\"\",\"994\":\",\",\"995\":\"\\\"\",\"996\":\"1\",\"997\":\"0\",\"998\":\"5\",\"999\":\"\\\"\",\"1000\":\":\",\"1001\":\"\\\"\",\"1002\":\":\",\"1003\":\"\\\"\",\"1004\":\",\",\"1005\":\"\\\"\",\"1006\":\"1\",\"1007\":\"0\",\"1008\":\"6\",\"1009\":\"\\\"\",\"1010\":\":\",\"1011\":\"\\\"\",\"1012\":\"\\\\\",\"1013\":\"\\\"\",\"1014\":\"\\\"\",\"1015\":\",\",\"1016\":\"\\\"\",\"1017\":\"1\",\"1018\":\"0\",\"1019\":\"7\",\"1020\":\"\\\"\",\"1021\":\":\",\"1022\":\"\\\"\",\"1023\":\"\\\\\",\"1024\":\"\\\\\",\"1025\":\"\\\"\",\"1026\":\",\",\"1027\":\"\\\"\",\"1028\":\"1\",\"1029\":\"0\",\"1030\":\"8\",\"1031\":\"\\\"\",\"1032\":\":\",\"1033\":\"\\\"\",\"1034\":\"\\\\\",\"1035\":\"\\\"\",\"1036\":\"\\\"\",\"1037\":\",\",\"1038\":\"\\\"\",\"1039\":\"1\",\"1040\":\"0\",\"1041\":\"9\",\"1042\":\"\\\"\",\"1043\":\":\",\"1044\":\"\\\"\",\"1045\":\"\\\\\",\"1046\":\"\\\"\",\"1047\":\"\\\"\",\"1048\":\",\",\"1049\":\"\\\"\",\"1050\":\"1\",\"1051\":\"1\",\"1052\":\"0\",\"1053\":\"\\\"\",\"1054\":\":\",\"1055\":\"\\\"\",\"1056\":\",\",\"1057\":\"\\\"\",\"1058\":\",\",\"1059\":\"\\\"\",\"1060\":\"1\",\"1061\":\"1\",\"1062\":\"1\",\"1063\":\"\\\"\",\"1064\":\":\",\"1065\":\"\\\"\",\"1066\":\"\\\\\",\"1067\":\"\\\"\",\"1068\":\"\\\"\",\"1069\":\",\",\"1070\":\"\\\"\",\"1071\":\"1\",\"1072\":\"1\",\"1073\":\"2\",\"1074\":\"\\\"\",\"1075\":\":\",\"1076\":\"\\\"\",\"1077\":\"1\",\"1078\":\"\\\"\",\"1079\":\",\",\"1080\":\"\\\"\",\"1081\":\"1\",\"1082\":\"1\",\"1083\":\"3\",\"1084\":\"\\\"\",\"1085\":\":\",\"1086\":\"\\\"\",\"1087\":\"3\",\"1088\":\"\\\"\",\"1089\":\",\",\"1090\":\"\\\"\",\"1091\":\"1\",\"1092\":\"1\",\"1093\":\"4\",\"1094\":\"\\\"\",\"1095\":\":\",\"1096\":\"\\\"\",\"1097\":\"\\\\\",\"1098\":\"\\\"\",\"1099\":\"\\\"\",\"1100\":\",\",\"1101\":\"\\\"\",\"1102\":\"1\",\"1103\":\"1\",\"1104\":\"5\",\"1105\":\"\\\"\",\"1106\":\":\",\"1107\":\"\\\"\",\"1108\":\":\",\"1109\":\"\\\"\",\"1110\":\",\",\"1111\":\"\\\"\",\"1112\":\"1\",\"1113\":\"1\",\"1114\":\"6\",\"1115\":\"\\\"\",\"1116\":\":\",\"1117\":\"\\\"\",\"1118\":\"\\\\\",\"1119\":\"\\\"\",\"1120\":\"\\\"\",\"1121\":\",\",\"1122\":\"\\\"\",\"1123\":\"1\",\"1124\":\"1\",\"1125\":\"7\",\"1126\":\"\\\"\",\"1127\":\":\",\"1128\":\"\\\"\",\"1129\":\"A\",\"1130\":\"\\\"\",\"1131\":\",\",\"1132\":\"\\\"\",\"1133\":\"1\",\"1134\":\"1\",\"1135\":\"8\",\"1136\":\"\\\"\",\"1137\":\":\",\"1138\":\"\\\"\",\"1139\":\"\\\\\",\"1140\":\"\\\"\",\"1141\":\"\\\"\",\"1142\":\",\",\"1143\":\"\\\"\",\"1144\":\"1\",\"1145\":\"1\",\"1146\":\"9\",\"1147\":\"\\\"\",\"1148\":\":\",\"1149\":\"\\\"\",\"1150\":\",\",\"1151\":\"\\\"\",\"1152\":\",\",\"1153\":\"\\\"\",\"1154\":\"1\",\"1155\":\"2\",\"1156\":\"0\",\"1157\":\"\\\"\",\"1158\":\":\",\"1159\":\"\\\"\",\"1160\":\"\\\\\",\"1161\":\"\\\"\",\"1162\":\"\\\"\",\"1163\":\",\",\"1164\":\"\\\"\",\"1165\":\"1\",\"1166\":\"2\",\"1167\":\"1\",\"1168\":\"\\\"\",\"1169\":\":\",\"1170\":\"\\\"\",\"1171\":\"1\",\"1172\":\"\\\"\",\"1173\":\",\",\"1174\":\"\\\"\",\"1175\":\"1\",\"1176\":\"2\",\"1177\":\"2\",\"1178\":\"\\\"\",\"1179\":\":\",\"1180\":\"\\\"\",\"1181\":\"4\",\"1182\":\"\\\"\",\"1183\":\",\",\"1184\":\"\\\"\",\"1185\":\"1\",\"1186\":\"2\",\"1187\":\"3\",\"1188\":\"\\\"\",\"1189\":\":\",\"1190\":\"\\\"\",\"1191\":\"\\\\\",\"1192\":\"\\\"\",\"1193\":\"\\\"\",\"1194\":\",\",\"1195\":\"\\\"\",\"1196\":\"1\",\"1197\":\"2\",\"1198\":\"4\",\"1199\":\"\\\"\",\"1200\":\":\",\"1201\":\"\\\"\",\"1202\":\":\",\"1203\":\"\\\"\",\"1204\":\",\",\"1205\":\"\\\"\",\"1206\":\"1\",\"1207\":\"2\",\"1208\":\"5\",\"1209\":\"\\\"\",\"1210\":\":\",\"1211\":\"\\\"\",\"1212\":\"\\\\\",\"1213\":\"\\\"\",\"1214\":\"\\\"\",\"1215\":\",\",\"1216\":\"\\\"\",\"1217\":\"1\",\"1218\":\"2\",\"1219\":\"6\",\"1220\":\"\\\"\",\"1221\":\":\",\"1222\":\"\\\"\",\"1223\":\"s\",\"1224\":\"\\\"\",\"1225\":\",\",\"1226\":\"\\\"\",\"1227\":\"1\",\"1228\":\"2\",\"1229\":\"7\",\"1230\":\"\\\"\",\"1231\":\":\",\"1232\":\"\\\"\",\"1233\":\"\\\\\",\"1234\":\"\\\"\",\"1235\":\"\\\"\",\"1236\":\",\",\"1237\":\"\\\"\",\"1238\":\"1\",\"1239\":\"2\",\"1240\":\"8\",\"1241\":\"\\\"\",\"1242\":\":\",\"1243\":\"\\\"\",\"1244\":\",\",\"1245\":\"\\\"\",\"1246\":\",\",\"1247\":\"\\\"\",\"1248\":\"1\",\"1249\":\"2\",\"1250\":\"9\",\"1251\":\"\\\"\",\"1252\":\":\",\"1253\":\"\\\"\",\"1254\":\"\\\\\",\"1255\":\"\\\"\",\"1256\":\"\\\"\",\"1257\":\",\",\"1258\":\"\\\"\",\"1259\":\"1\",\"1260\":\"3\",\"1261\":\"0\",\"1262\":\"\\\"\",\"1263\":\":\",\"1264\":\"\\\"\",\"1265\":\"1\",\"1266\":\"\\\"\",\"1267\":\",\",\"1268\":\"\\\"\",\"1269\":\"1\",\"1270\":\"3\",\"1271\":\"1\",\"1272\":\"\\\"\",\"1273\":\":\",\"1274\":\"\\\"\",\"1275\":\"5\",\"1276\":\"\\\"\",\"1277\":\",\",\"1278\":\"\\\"\",\"1279\":\"1\",\"1280\":\"3\",\"1281\":\"2\",\"1282\":\"\\\"\",\"1283\":\":\",\"1284\":\"\\\"\",\"1285\":\"\\\\\",\"1286\":\"\\\"\",\"1287\":\"\\\"\",\"1288\":\",\",\"1289\":\"\\\"\",\"1290\":\"1\",\"1291\":\"3\",\"1292\":\"3\",\"1293\":\"\\\"\",\"1294\":\":\",\"1295\":\"\\\"\",\"1296\":\":\",\"1297\":\"\\\"\",\"1298\":\",\",\"1299\":\"\\\"\",\"1300\":\"1\",\"1301\":\"3\",\"1302\":\"4\",\"1303\":\"\\\"\",\"1304\":\":\",\"1305\":\"\\\"\",\"1306\":\"\\\\\",\"1307\":\"\\\"\",\"1308\":\"\\\"\",\"1309\":\",\",\"1310\":\"\\\"\",\"1311\":\"1\",\"1312\":\"3\",\"1313\":\"5\",\"1314\":\"\\\"\",\"1315\":\":\",\"1316\":\"\\\"\",\"1317\":\"i\",\"1318\":\"\\\"\",\"1319\":\",\",\"1320\":\"\\\"\",\"1321\":\"1\",\"1322\":\"3\",\"1323\":\"6\",\"1324\":\"\\\"\",\"1325\":\":\",\"1326\":\"\\\"\",\"1327\":\"\\\\\",\"1328\":\"\\\"\",\"1329\":\"\\\"\",\"1330\":\",\",\"1331\":\"\\\"\",\"1332\":\"1\",\"1333\":\"3\",\"1334\":\"7\",\"1335\":\"\\\"\",\"1336\":\":\",\"1337\":\"\\\"\",\"1338\":\",\",\"1339\":\"\\\"\",\"1340\":\",\",\"1341\":\"\\\"\",\"1342\":\"1\",\"1343\":\"3\",\"1344\":\"8\",\"1345\":\"\\\"\",\"1346\":\":\",\"1347\":\"\\\"\",\"1348\":\"\\\\\",\"1349\":\"\\\"\",\"1350\":\"\\\"\",\"1351\":\",\",\"1352\":\"\\\"\",\"1353\":\"1\",\"1354\":\"3\",\"1355\":\"9\",\"1356\":\"\\\"\",\"1357\":\":\",\"1358\":\"\\\"\",\"1359\":\"1\",\"1360\":\"\\\"\",\"1361\":\",\",\"1362\":\"\\\"\",\"1363\":\"1\",\"1364\":\"4\",\"1365\":\"0\",\"1366\":\"\\\"\",\"1367\":\":\",\"1368\":\"\\\"\",\"1369\":\"6\",\"1370\":\"\\\"\",\"1371\":\",\",\"1372\":\"\\\"\",\"1373\":\"1\",\"1374\":\"4\",\"1375\":\"1\",\"1376\":\"\\\"\",\"1377\":\":\",\"1378\":\"\\\"\",\"1379\":\"\\\\\",\"1380\":\"\\\"\",\"1381\":\"\\\"\",\"1382\":\",\",\"1383\":\"\\\"\",\"1384\":\"1\",\"1385\":\"4\",\"1386\":\"2\",\"1387\":\"\\\"\",\"1388\":\":\",\"1389\":\"\\\"\",\"1390\":\":\",\"1391\":\"\\\"\",\"1392\":\",\",\"1393\":\"\\\"\",\"1394\":\"1\",\"1395\":\"4\",\"1396\":\"3\",\"1397\":\"\\\"\",\"1398\":\":\",\"1399\":\"\\\"\",\"1400\":\"\\\\\",\"1401\":\"\\\"\",\"1402\":\"\\\"\",\"1403\":\",\",\"1404\":\"\\\"\",\"1405\":\"1\",\"1406\":\"4\",\"1407\":\"4\",\"1408\":\"\\\"\",\"1409\":\":\",\"1410\":\"\\\"\",\"1411\":\"a\",\"1412\":\"\\\"\",\"1413\":\",\",\"1414\":\"\\\"\",\"1415\":\"1\",\"1416\":\"4\",\"1417\":\"5\",\"1418\":\"\\\"\",\"1419\":\":\",\"1420\":\"\\\"\",\"1421\":\"\\\\\",\"1422\":\"\\\"\",\"1423\":\"\\\"\",\"1424\":\",\",\"1425\":\"\\\"\",\"1426\":\"1\",\"1427\":\"4\",\"1428\":\"6\",\"1429\":\"\\\"\",\"1430\":\":\",\"1431\":\"\\\"\",\"1432\":\",\",\"1433\":\"\\\"\",\"1434\":\",\",\"1435\":\"\\\"\",\"1436\":\"1\",\"1437\":\"4\",\"1438\":\"7\",\"1439\":\"\\\"\",\"1440\":\":\",\"1441\":\"\\\"\",\"1442\":\"\\\\\",\"1443\":\"\\\"\",\"1444\":\"\\\"\",\"1445\":\",\",\"1446\":\"\\\"\",\"1447\":\"1\",\"1448\":\"4\",\"1449\":\"8\",\"1450\":\"\\\"\",\"1451\":\":\",\"1452\":\"\\\"\",\"1453\":\"1\",\"1454\":\"\\\"\",\"1455\":\",\",\"1456\":\"\\\"\",\"1457\":\"1\",\"1458\":\"4\",\"1459\":\"9\",\"1460\":\"\\\"\",\"1461\":\":\",\"1462\":\"\\\"\",\"1463\":\"7\",\"1464\":\"\\\"\",\"1465\":\",\",\"1466\":\"\\\"\",\"1467\":\"1\",\"1468\":\"5\",\"1469\":\"0\",\"1470\":\"\\\"\",\"1471\":\":\",\"1472\":\"\\\"\",\"1473\":\"\\\\\",\"1474\":\"\\\"\",\"1475\":\"\\\"\",\"1476\":\",\",\"1477\":\"\\\"\",\"1478\":\"1\",\"1479\":\"5\",\"1480\":\"1\",\"1481\":\"\\\"\",\"1482\":\":\",\"1483\":\"\\\"\",\"1484\":\":\",\"1485\":\"\\\"\",\"1486\":\",\",\"1487\":\"\\\"\",\"1488\":\"1\",\"1489\":\"5\",\"1490\":\"2\",\"1491\":\"\\\"\",\"1492\":\":\",\"1493\":\"\\\"\",\"1494\":\"\\\\\",\"1495\":\"\\\"\",\"1496\":\"\\\"\",\"1497\":\",\",\"1498\":\"\\\"\",\"1499\":\"1\",\"1500\":\"5\",\"1501\":\"3\",\"1502\":\"\\\"\",\"1503\":\":\",\"1504\":\"\\\"\",\"1505\":\"/\",\"1506\":\"\\\"\",\"1507\":\",\",\"1508\":\"\\\"\",\"1509\":\"1\",\"1510\":\"5\",\"1511\":\"4\",\"1512\":\"\\\"\",\"1513\":\":\",\"1514\":\"\\\"\",\"1515\":\"\\\\\",\"1516\":\"\\\"\",\"1517\":\"\\\"\",\"1518\":\",\",\"1519\":\"\\\"\",\"1520\":\"1\",\"1521\":\"5\",\"1522\":\"5\",\"1523\":\"\\\"\",\"1524\":\":\",\"1525\":\"\\\"\",\"1526\":\",\",\"1527\":\"\\\"\",\"1528\":\",\",\"1529\":\"\\\"\",\"1530\":\"1\",\"1531\":\"5\",\"1532\":\"6\",\"1533\":\"\\\"\",\"1534\":\":\",\"1535\":\"\\\"\",\"1536\":\"\\\\\",\"1537\":\"\\\"\",\"1538\":\"\\\"\",\"1539\":\",\",\"1540\":\"\\\"\",\"1541\":\"1\",\"1542\":\"5\",\"1543\":\"7\",\"1544\":\"\\\"\",\"1545\":\":\",\"1546\":\"\\\"\",\"1547\":\"1\",\"1548\":\"\\\"\",\"1549\":\",\",\"1550\":\"\\\"\",\"1551\":\"1\",\"1552\":\"5\",\"1553\":\"8\",\"1554\":\"\\\"\",\"1555\":\":\",\"1556\":\"\\\"\",\"1557\":\"8\",\"1558\":\"\\\"\",\"1559\":\",\",\"1560\":\"\\\"\",\"1561\":\"1\",\"1562\":\"5\",\"1563\":\"9\",\"1564\":\"\\\"\",\"1565\":\":\",\"1566\":\"\\\"\",\"1567\":\"\\\\\",\"1568\":\"\\\"\",\"1569\":\"\\\"\",\"1570\":\",\",\"1571\":\"\\\"\",\"1572\":\"1\",\"1573\":\"6\",\"1574\":\"0\",\"1575\":\"\\\"\",\"1576\":\":\",\"1577\":\"\\\"\",\"1578\":\":\",\"1579\":\"\\\"\",\"1580\":\",\",\"1581\":\"\\\"\",\"1582\":\"1\",\"1583\":\"6\",\"1584\":\"1\",\"1585\":\"\\\"\",\"1586\":\":\",\"1587\":\"\\\"\",\"1588\":\"\\\\\",\"1589\":\"\\\"\",\"1590\":\"\\\"\",\"1591\":\",\",\"1592\":\"\\\"\",\"1593\":\"1\",\"1594\":\"6\",\"1595\":\"2\",\"1596\":\"\\\"\",\"1597\":\":\",\"1598\":\"\\\"\",\"1599\":\"K\",\"1600\":\"\\\"\",\"1601\":\",\",\"1602\":\"\\\"\",\"1603\":\"1\",\"1604\":\"6\",\"1605\":\"3\",\"1606\":\"\\\"\",\"1607\":\":\",\"1608\":\"\\\"\",\"1609\":\"\\\\\",\"1610\":\"\\\"\",\"1611\":\"\\\"\",\"1612\":\",\",\"1613\":\"\\\"\",\"1614\":\"1\",\"1615\":\"6\",\"1616\":\"4\",\"1617\":\"\\\"\",\"1618\":\":\",\"1619\":\"\\\"\",\"1620\":\",\",\"1621\":\"\\\"\",\"1622\":\",\",\"1623\":\"\\\"\",\"1624\":\"1\",\"1625\":\"6\",\"1626\":\"5\",\"1627\":\"\\\"\",\"1628\":\":\",\"1629\":\"\\\"\",\"1630\":\"\\\\\",\"1631\":\"\\\"\",\"1632\":\"\\\"\",\"1633\":\",\",\"1634\":\"\\\"\",\"1635\":\"1\",\"1636\":\"6\",\"1637\":\"6\",\"1638\":\"\\\"\",\"1639\":\":\",\"1640\":\"\\\"\",\"1641\":\"1\",\"1642\":\"\\\"\",\"1643\":\",\",\"1644\":\"\\\"\",\"1645\":\"1\",\"1646\":\"6\",\"1647\":\"7\",\"1648\":\"\\\"\",\"1649\":\":\",\"1650\":\"\\\"\",\"1651\":\"9\",\"1652\":\"\\\"\",\"1653\":\",\",\"1654\":\"\\\"\",\"1655\":\"1\",\"1656\":\"6\",\"1657\":\"8\",\"1658\":\"\\\"\",\"1659\":\":\",\"1660\":\"\\\"\",\"1661\":\"\\\\\",\"1662\":\"\\\"\",\"1663\":\"\\\"\",\"1664\":\",\",\"1665\":\"\\\"\",\"1666\":\"1\",\"1667\":\"6\",\"1668\":\"9\",\"1669\":\"\\\"\",\"1670\":\":\",\"1671\":\"\\\"\",\"1672\":\":\",\"1673\":\"\\\"\",\"1674\":\",\",\"1675\":\"\\\"\",\"1676\":\"1\",\"1677\":\"7\",\"1678\":\"0\",\"1679\":\"\\\"\",\"1680\":\":\",\"1681\":\"\\\"\",\"1682\":\"\\\\\",\"1683\":\"\\\"\",\"1684\":\"\\\"\",\"1685\":\",\",\"1686\":\"\\\"\",\"1687\":\"1\",\"1688\":\"7\",\"1689\":\"1\",\"1690\":\"\\\"\",\"1691\":\":\",\"1692\":\"\\\"\",\"1693\":\"o\",\"1694\":\"\\\"\",\"1695\":\",\",\"1696\":\"\\\"\",\"1697\":\"1\",\"1698\":\"7\",\"1699\":\"2\",\"1700\":\"\\\"\",\"1701\":\":\",\"1702\":\"\\\"\",\"1703\":\"\\\\\",\"1704\":\"\\\"\",\"1705\":\"\\\"\",\"1706\":\",\",\"1707\":\"\\\"\",\"1708\":\"1\",\"1709\":\"7\",\"1710\":\"3\",\"1711\":\"\\\"\",\"1712\":\":\",\"1713\":\"\\\"\",\"1714\":\",\",\"1715\":\"\\\"\",\"1716\":\",\",\"1717\":\"\\\"\",\"1718\":\"1\",\"1719\":\"7\",\"1720\":\"4\",\"1721\":\"\\\"\",\"1722\":\":\",\"1723\":\"\\\"\",\"1724\":\"\\\\\",\"1725\":\"\\\"\",\"1726\":\"\\\"\",\"1727\":\",\",\"1728\":\"\\\"\",\"1729\":\"1\",\"1730\":\"7\",\"1731\":\"5\",\"1732\":\"\\\"\",\"1733\":\":\",\"1734\":\"\\\"\",\"1735\":\"2\",\"1736\":\"\\\"\",\"1737\":\",\",\"1738\":\"\\\"\",\"1739\":\"1\",\"1740\":\"7\",\"1741\":\"6\",\"1742\":\"\\\"\",\"1743\":\":\",\"1744\":\"\\\"\",\"1745\":\"0\",\"1746\":\"\\\"\",\"1747\":\",\",\"1748\":\"\\\"\",\"1749\":\"1\",\"1750\":\"7\",\"1751\":\"7\",\"1752\":\"\\\"\",\"1753\":\":\",\"1754\":\"\\\"\",\"1755\":\"\\\\\",\"1756\":\"\\\"\",\"1757\":\"\\\"\",\"1758\":\",\",\"1759\":\"\\\"\",\"1760\":\"1\",\"1761\":\"7\",\"1762\":\"8\",\"1763\":\"\\\"\",\"1764\":\":\",\"1765\":\"\\\"\",\"1766\":\":\",\"1767\":\"\\\"\",\"1768\":\",\",\"1769\":\"\\\"\",\"1770\":\"1\",\"1771\":\"7\",\"1772\":\"9\",\"1773\":\"\\\"\",\"1774\":\":\",\"1775\":\"\\\"\",\"1776\":\"\\\\\",\"1777\":\"\\\"\",\"1778\":\"\\\"\",\"1779\":\",\",\"1780\":\"\\\"\",\"1781\":\"1\",\"1782\":\"8\",\"1783\":\"0\",\"1784\":\"\\\"\",\"1785\":\":\",\"1786\":\"\\\"\",\"1787\":\"l\",\"1788\":\"\\\"\",\"1789\":\",\",\"1790\":\"\\\"\",\"1791\":\"1\",\"1792\":\"8\",\"1793\":\"1\",\"1794\":\"\\\"\",\"1795\":\":\",\"1796\":\"\\\"\",\"1797\":\"\\\\\",\"1798\":\"\\\"\",\"1799\":\"\\\"\",\"1800\":\",\",\"1801\":\"\\\"\",\"1802\":\"1\",\"1803\":\"8\",\"1804\":\"2\",\"1805\":\"\\\"\",\"1806\":\":\",\"1807\":\"\\\"\",\"1808\":\",\",\"1809\":\"\\\"\",\"1810\":\",\",\"1811\":\"\\\"\",\"1812\":\"1\",\"1813\":\"8\",\"1814\":\"3\",\"1815\":\"\\\"\",\"1816\":\":\",\"1817\":\"\\\"\",\"1818\":\"\\\\\",\"1819\":\"\\\"\",\"1820\":\"\\\"\",\"1821\":\",\",\"1822\":\"\\\"\",\"1823\":\"1\",\"1824\":\"8\",\"1825\":\"4\",\"1826\":\"\\\"\",\"1827\":\":\",\"1828\":\"\\\"\",\"1829\":\"2\",\"1830\":\"\\\"\",\"1831\":\",\",\"1832\":\"\\\"\",\"1833\":\"1\",\"1834\":\"8\",\"1835\":\"5\",\"1836\":\"\\\"\",\"1837\":\":\",\"1838\":\"\\\"\",\"1839\":\"1\",\"1840\":\"\\\"\",\"1841\":\",\",\"1842\":\"\\\"\",\"1843\":\"1\",\"1844\":\"8\",\"1845\":\"6\",\"1846\":\"\\\"\",\"1847\":\":\",\"1848\":\"\\\"\",\"1849\":\"\\\\\",\"1850\":\"\\\"\",\"1851\":\"\\\"\",\"1852\":\",\",\"1853\":\"\\\"\",\"1854\":\"1\",\"1855\":\"8\",\"1856\":\"7\",\"1857\":\"\\\"\",\"1858\":\":\",\"1859\":\"\\\"\",\"1860\":\":\",\"1861\":\"\\\"\",\"1862\":\",\",\"1863\":\"\\\"\",\"1864\":\"1\",\"1865\":\"8\",\"1866\":\"8\",\"1867\":\"\\\"\",\"1868\":\":\",\"1869\":\"\\\"\",\"1870\":\"\\\\\",\"1871\":\"\\\"\",\"1872\":\"\\\"\",\"1873\":\",\",\"1874\":\"\\\"\",\"1875\":\"1\",\"1876\":\"8\",\"1877\":\"9\",\"1878\":\"\\\"\",\"1879\":\":\",\"1880\":\"\\\"\",\"1881\":\"k\",\"1882\":\"\\\"\",\"1883\":\",\",\"1884\":\"\\\"\",\"1885\":\"1\",\"1886\":\"9\",\"1887\":\"0\",\"1888\":\"\\\"\",\"1889\":\":\",\"1890\":\"\\\"\",\"1891\":\"\\\\\",\"1892\":\"\\\"\",\"1893\":\"\\\"\",\"1894\":\",\",\"1895\":\"\\\"\",\"1896\":\"1\",\"1897\":\"9\",\"1898\":\"1\",\"1899\":\"\\\"\",\"1900\":\":\",\"1901\":\"\\\"\",\"1902\":\",\",\"1903\":\"\\\"\",\"1904\":\",\",\"1905\":\"\\\"\",\"1906\":\"1\",\"1907\":\"9\",\"1908\":\"2\",\"1909\":\"\\\"\",\"1910\":\":\",\"1911\":\"\\\"\",\"1912\":\"\\\\\",\"1913\":\"\\\"\",\"1914\":\"\\\"\",\"1915\":\",\",\"1916\":\"\\\"\",\"1917\":\"1\",\"1918\":\"9\",\"1919\":\"3\",\"1920\":\"\\\"\",\"1921\":\":\",\"1922\":\"\\\"\",\"1923\":\"2\",\"1924\":\"\\\"\",\"1925\":\",\",\"1926\":\"\\\"\",\"1927\":\"1\",\"1928\":\"9\",\"1929\":\"4\",\"1930\":\"\\\"\",\"1931\":\":\",\"1932\":\"\\\"\",\"1933\":\"2\",\"1934\":\"\\\"\",\"1935\":\",\",\"1936\":\"\\\"\",\"1937\":\"1\",\"1938\":\"9\",\"1939\":\"5\",\"1940\":\"\\\"\",\"1941\":\":\",\"1942\":\"\\\"\",\"1943\":\"\\\\\",\"1944\":\"\\\"\",\"1945\":\"\\\"\",\"1946\":\",\",\"1947\":\"\\\"\",\"1948\":\"1\",\"1949\":\"9\",\"1950\":\"6\",\"1951\":\"\\\"\",\"1952\":\":\",\"1953\":\"\\\"\",\"1954\":\":\",\"1955\":\"\\\"\",\"1956\":\",\",\"1957\":\"\\\"\",\"1958\":\"1\",\"1959\":\"9\",\"1960\":\"7\",\"1961\":\"\\\"\",\"1962\":\":\",\"1963\":\"\\\"\",\"1964\":\"\\\\\",\"1965\":\"\\\"\",\"1966\":\"\\\"\",\"1967\":\",\",\"1968\":\"\\\"\",\"1969\":\"1\",\"1970\":\"9\",\"1971\":\"8\",\"1972\":\"\\\"\",\"1973\":\":\",\"1974\":\"\\\"\",\"1975\":\"a\",\"1976\":\"\\\"\",\"1977\":\",\",\"1978\":\"\\\"\",\"1979\":\"1\",\"1980\":\"9\",\"1981\":\"9\",\"1982\":\"\\\"\",\"1983\":\":\",\"1984\":\"\\\"\",\"1985\":\"\\\\\",\"1986\":\"\\\"\",\"1987\":\"\\\"\",\"1988\":\",\",\"1989\":\"\\\"\",\"1990\":\"2\",\"1991\":\"0\",\"1992\":\"0\",\"1993\":\"\\\"\",\"1994\":\":\",\"1995\":\"\\\"\",\"1996\":\",\",\"1997\":\"\\\"\",\"1998\":\",\",\"1999\":\"\\\"\",\"2000\":\"2\",\"2001\":\"0\",\"2002\":\"1\",\"2003\":\"\\\"\",\"2004\":\":\",\"2005\":\"\\\"\",\"2006\":\"\\\\\",\"2007\":\"\\\"\",\"2008\":\"\\\"\",\"2009\":\",\",\"2010\":\"\\\"\",\"2011\":\"2\",\"2012\":\"0\",\"2013\":\"2\",\"2014\":\"\\\"\",\"2015\":\":\",\"2016\":\"\\\"\",\"2017\":\"2\",\"2018\":\"\\\"\",\"2019\":\",\",\"2020\":\"\\\"\",\"2021\":\"2\",\"2022\":\"0\",\"2023\":\"3\",\"2024\":\"\\\"\",\"2025\":\":\",\"2026\":\"\\\"\",\"2027\":\"3\",\"2028\":\"\\\"\",\"2029\":\",\",\"2030\":\"\\\"\",\"2031\":\"2\",\"2032\":\"0\",\"2033\":\"4\",\"2034\":\"\\\"\",\"2035\":\":\",\"2036\":\"\\\"\",\"2037\":\"\\\\\",\"2038\":\"\\\"\",\"2039\":\"\\\"\",\"2040\":\",\",\"2041\":\"\\\"\",\"2042\":\"2\",\"2043\":\"0\",\"2044\":\"5\",\"2045\":\"\\\"\",\"2046\":\":\",\"2047\":\"\\\"\",\"2048\":\":\",\"2049\":\"\\\"\",\"2050\":\",\",\"2051\":\"\\\"\",\"2052\":\"2\",\"2053\":\"0\",\"2054\":\"6\",\"2055\":\"\\\"\",\"2056\":\":\",\"2057\":\"\\\"\",\"2058\":\"\\\\\",\"2059\":\"\\\"\",\"2060\":\"\\\"\",\"2061\":\",\",\"2062\":\"\\\"\",\"2063\":\"2\",\"2064\":\"0\",\"2065\":\"7\",\"2066\":\"\\\"\",\"2067\":\":\",\"2068\":\"\\\"\",\"2069\":\"t\",\"2070\":\"\\\"\",\"2071\":\",\",\"2072\":\"\\\"\",\"2073\":\"2\",\"2074\":\"0\",\"2075\":\"8\",\"2076\":\"\\\"\",\"2077\":\":\",\"2078\":\"\\\"\",\"2079\":\"\\\\\",\"2080\":\"\\\"\",\"2081\":\"\\\"\",\"2082\":\",\",\"2083\":\"\\\"\",\"2084\":\"2\",\"2085\":\"0\",\"2086\":\"9\",\"2087\":\"\\\"\",\"2088\":\":\",\"2089\":\"\\\"\",\"2090\":\",\",\"2091\":\"\\\"\",\"2092\":\",\",\"2093\":\"\\\"\",\"2094\":\"2\",\"2095\":\"1\",\"2096\":\"0\",\"2097\":\"\\\"\",\"2098\":\":\",\"2099\":\"\\\"\",\"2100\":\"\\\\\",\"2101\":\"\\\"\",\"2102\":\"\\\"\",\"2103\":\",\",\"2104\":\"\\\"\",\"2105\":\"2\",\"2106\":\"1\",\"2107\":\"1\",\"2108\":\"\\\"\",\"2109\":\":\",\"2110\":\"\\\"\",\"2111\":\"2\",\"2112\":\"\\\"\",\"2113\":\",\",\"2114\":\"\\\"\",\"2115\":\"2\",\"2116\":\"1\",\"2117\":\"2\",\"2118\":\"\\\"\",\"2119\":\":\",\"2120\":\"\\\"\",\"2121\":\"4\",\"2122\":\"\\\"\",\"2123\":\",\",\"2124\":\"\\\"\",\"2125\":\"2\",\"2126\":\"1\",\"2127\":\"3\",\"2128\":\"\\\"\",\"2129\":\":\",\"2130\":\"\\\"\",\"2131\":\"\\\\\",\"2132\":\"\\\"\",\"2133\":\"\\\"\",\"2134\":\",\",\"2135\":\"\\\"\",\"2136\":\"2\",\"2137\":\"1\",\"2138\":\"4\",\"2139\":\"\\\"\",\"2140\":\":\",\"2141\":\"\\\"\",\"2142\":\":\",\"2143\":\"\\\"\",\"2144\":\",\",\"2145\":\"\\\"\",\"2146\":\"2\",\"2147\":\"1\",\"2148\":\"5\",\"2149\":\"\\\"\",\"2150\":\":\",\"2151\":\"\\\"\",\"2152\":\"\\\\\",\"2153\":\"\\\"\",\"2154\":\"\\\"\",\"2155\":\",\",\"2156\":\"\\\"\",\"2157\":\"2\",\"2158\":\"1\",\"2159\":\"6\",\"2160\":\"\\\"\",\"2161\":\":\",\"2162\":\"\\\"\",\"2163\":\"a\",\"2164\":\"\\\"\",\"2165\":\",\",\"2166\":\"\\\"\",\"2167\":\"2\",\"2168\":\"1\",\"2169\":\"7\",\"2170\":\"\\\"\",\"2171\":\":\",\"2172\":\"\\\"\",\"2173\":\"\\\\\",\"2174\":\"\\\"\",\"2175\":\"\\\"\",\"2176\":\",\",\"2177\":\"\\\"\",\"2178\":\"2\",\"2179\":\"1\",\"2180\":\"8\",\"2181\":\"\\\"\",\"2182\":\":\",\"2183\":\"\\\"\",\"2184\":\",\",\"2185\":\"\\\"\",\"2186\":\",\",\"2187\":\"\\\"\",\"2188\":\"2\",\"2189\":\"1\",\"2190\":\"9\",\"2191\":\"\\\"\",\"2192\":\":\",\"2193\":\"\\\"\",\"2194\":\"\\\\\",\"2195\":\"\\\"\",\"2196\":\"\\\"\",\"2197\":\",\",\"2198\":\"\\\"\",\"2199\":\"2\",\"2200\":\"2\",\"2201\":\"0\",\"2202\":\"\\\"\",\"2203\":\":\",\"2204\":\"\\\"\",\"2205\":\"2\",\"2206\":\"\\\"\",\"2207\":\",\",\"2208\":\"\\\"\",\"2209\":\"2\",\"2210\":\"2\",\"2211\":\"1\",\"2212\":\"\\\"\",\"2213\":\":\",\"2214\":\"\\\"\",\"2215\":\"5\",\"2216\":\"\\\"\",\"2217\":\",\",\"2218\":\"\\\"\",\"2219\":\"2\",\"2220\":\"2\",\"2221\":\"2\",\"2222\":\"\\\"\",\"2223\":\":\",\"2224\":\"\\\"\",\"2225\":\"\\\\\",\"2226\":\"\\\"\",\"2227\":\"\\\"\",\"2228\":\",\",\"2229\":\"\\\"\",\"2230\":\"2\",\"2231\":\"2\",\"2232\":\"3\",\"2233\":\"\\\"\",\"2234\":\":\",\"2235\":\"\\\"\",\"2236\":\":\",\"2237\":\"\\\"\",\"2238\":\",\",\"2239\":\"\\\"\",\"2240\":\"2\",\"2241\":\"2\",\"2242\":\"4\",\"2243\":\"\\\"\",\"2244\":\":\",\"2245\":\"\\\"\",\"2246\":\"\\\\\",\"2247\":\"\\\"\",\"2248\":\"\\\"\",\"2249\":\",\",\"2250\":\"\\\"\",\"2251\":\"2\",\"2252\":\"2\",\"2253\":\"5\",\"2254\":\"\\\"\",\"2255\":\":\",\"2256\":\"\\\"\",\"2257\":\"\\\\\",\"2258\":\"\\\\\",\"2259\":\"\\\"\",\"2260\":\",\",\"2261\":\"\\\"\",\"2262\":\"2\",\"2263\":\"2\",\"2264\":\"6\",\"2265\":\"\\\"\",\"2266\":\":\",\"2267\":\"\\\"\",\"2268\":\"\\\\\",\"2269\":\"\\\"\",\"2270\":\"\\\"\",\"2271\":\",\",\"2272\":\"\\\"\",\"2273\":\"2\",\"2274\":\"2\",\"2275\":\"7\",\"2276\":\"\\\"\",\"2277\":\":\",\"2278\":\"\\\"\",\"2279\":\"\\\\\",\"2280\":\"\\\"\",\"2281\":\"\\\"\",\"2282\":\",\",\"2283\":\"\\\"\",\"2284\":\"2\",\"2285\":\"2\",\"2286\":\"8\",\"2287\":\"\\\"\",\"2288\":\":\",\"2289\":\"\\\"\",\"2290\":\",\",\"2291\":\"\\\"\",\"2292\":\",\",\"2293\":\"\\\"\",\"2294\":\"2\",\"2295\":\"2\",\"2296\":\"9\",\"2297\":\"\\\"\",\"2298\":\":\",\"2299\":\"\\\"\",\"2300\":\"\\\\\",\"2301\":\"\\\"\",\"2302\":\"\\\"\",\"2303\":\",\",\"2304\":\"\\\"\",\"2305\":\"2\",\"2306\":\"3\",\"2307\":\"0\",\"2308\":\"\\\"\",\"2309\":\":\",\"2310\":\"\\\"\",\"2311\":\"2\",\"2312\":\"\\\"\",\"2313\":\",\",\"2314\":\"\\\"\",\"2315\":\"2\",\"2316\":\"3\",\"2317\":\"1\",\"2318\":\"\\\"\",\"2319\":\":\",\"2320\":\"\\\"\",\"2321\":\"6\",\"2322\":\"\\\"\",\"2323\":\",\",\"2324\":\"\\\"\",\"2325\":\"2\",\"2326\":\"3\",\"2327\":\"2\",\"2328\":\"\\\"\",\"2329\":\":\",\"2330\":\"\\\"\",\"2331\":\"\\\\\",\"2332\":\"\\\"\",\"2333\":\"\\\"\",\"2334\":\",\",\"2335\":\"\\\"\",\"2336\":\"2\",\"2337\":\"3\",\"2338\":\"3\",\"2339\":\"\\\"\",\"2340\":\":\",\"2341\":\"\\\"\",\"2342\":\":\",\"2343\":\"\\\"\",\"2344\":\",\",\"2345\":\"\\\"\",\"2346\":\"2\",\"2347\":\"3\",\"2348\":\"4\",\"2349\":\"\\\"\",\"2350\":\":\",\"2351\":\"\\\"\",\"2352\":\"\\\\\",\"2353\":\"\\\"\",\"2354\":\"\\\"\",\"2355\":\",\",\"2356\":\"\\\"\",\"2357\":\"2\",\"2358\":\"3\",\"2359\":\"5\",\"2360\":\"\\\"\",\"2361\":\":\",\"2362\":\"\\\"\",\"2363\":\",\",\"2364\":\"\\\"\",\"2365\":\",\",\"2366\":\"\\\"\",\"2367\":\"2\",\"2368\":\"3\",\"2369\":\"6\",\"2370\":\"\\\"\",\"2371\":\":\",\"2372\":\"\\\"\",\"2373\":\"\\\\\",\"2374\":\"\\\"\",\"2375\":\"\\\"\",\"2376\":\",\",\"2377\":\"\\\"\",\"2378\":\"2\",\"2379\":\"3\",\"2380\":\"7\",\"2381\":\"\\\"\",\"2382\":\":\",\"2383\":\"\\\"\",\"2384\":\",\",\"2385\":\"\\\"\",\"2386\":\",\",\"2387\":\"\\\"\",\"2388\":\"2\",\"2389\":\"3\",\"2390\":\"8\",\"2391\":\"\\\"\",\"2392\":\":\",\"2393\":\"\\\"\",\"2394\":\"\\\\\",\"2395\":\"\\\"\",\"2396\":\"\\\"\",\"2397\":\",\",\"2398\":\"\\\"\",\"2399\":\"2\",\"2400\":\"3\",\"2401\":\"9\",\"2402\":\"\\\"\",\"2403\":\":\",\"2404\":\"\\\"\",\"2405\":\"2\",\"2406\":\"\\\"\",\"2407\":\",\",\"2408\":\"\\\"\",\"2409\":\"2\",\"2410\":\"4\",\"2411\":\"0\",\"2412\":\"\\\"\",\"2413\":\":\",\"2414\":\"\\\"\",\"2415\":\"7\",\"2416\":\"\\\"\",\"2417\":\",\",\"2418\":\"\\\"\",\"2419\":\"2\",\"2420\":\"4\",\"2421\":\"1\",\"2422\":\"\\\"\",\"2423\":\":\",\"2424\":\"\\\"\",\"2425\":\"\\\\\",\"2426\":\"\\\"\",\"2427\":\"\\\"\",\"2428\":\",\",\"2429\":\"\\\"\",\"2430\":\"2\",\"2431\":\"4\",\"2432\":\"2\",\"2433\":\"\\\"\",\"2434\":\":\",\"2435\":\"\\\"\",\"2436\":\":\",\"2437\":\"\\\"\",\"2438\":\",\",\"2439\":\"\\\"\",\"2440\":\"2\",\"2441\":\"4\",\"2442\":\"3\",\"2443\":\"\\\"\",\"2444\":\":\",\"2445\":\"\\\"\",\"2446\":\"\\\\\",\"2447\":\"\\\"\",\"2448\":\"\\\"\",\"2449\":\",\",\"2450\":\"\\\"\",\"2451\":\"2\",\"2452\":\"4\",\"2453\":\"4\",\"2454\":\"\\\"\",\"2455\":\":\",\"2456\":\"\\\"\",\"2457\":\"\\\\\",\"2458\":\"\\\\\",\"2459\":\"\\\"\",\"2460\":\",\",\"2461\":\"\\\"\",\"2462\":\"2\",\"2463\":\"4\",\"2464\":\"5\",\"2465\":\"\\\"\",\"2466\":\":\",\"2467\":\"\\\"\",\"2468\":\"\\\\\",\"2469\":\"\\\"\",\"2470\":\"\\\"\",\"2471\":\",\",\"2472\":\"\\\"\",\"2473\":\"2\",\"2474\":\"4\",\"2475\":\"6\",\"2476\":\"\\\"\",\"2477\":\":\",\"2478\":\"\\\"\",\"2479\":\"\\\\\",\"2480\":\"\\\"\",\"2481\":\"\\\"\",\"2482\":\",\",\"2483\":\"\\\"\",\"2484\":\"2\",\"2485\":\"4\",\"2486\":\"7\",\"2487\":\"\\\"\",\"2488\":\":\",\"2489\":\"\\\"\",\"2490\":\",\",\"2491\":\"\\\"\",\"2492\":\",\",\"2493\":\"\\\"\",\"2494\":\"2\",\"2495\":\"4\",\"2496\":\"8\",\"2497\":\"\\\"\",\"2498\":\":\",\"2499\":\"\\\"\",\"2500\":\"\\\\\",\"2501\":\"\\\"\",\"2502\":\"\\\"\",\"2503\":\",\",\"2504\":\"\\\"\",\"2505\":\"2\",\"2506\":\"4\",\"2507\":\"9\",\"2508\":\"\\\"\",\"2509\":\":\",\"2510\":\"\\\"\",\"2511\":\"2\",\"2512\":\"\\\"\",\"2513\":\",\",\"2514\":\"\\\"\",\"2515\":\"2\",\"2516\":\"5\",\"2517\":\"0\",\"2518\":\"\\\"\",\"2519\":\":\",\"2520\":\"\\\"\",\"2521\":\"8\",\"2522\":\"\\\"\",\"2523\":\",\",\"2524\":\"\\\"\",\"2525\":\"2\",\"2526\":\"5\",\"2527\":\"1\",\"2528\":\"\\\"\",\"2529\":\":\",\"2530\":\"\\\"\",\"2531\":\"\\\\\",\"2532\":\"\\\"\",\"2533\":\"\\\"\",\"2534\":\",\",\"2535\":\"\\\"\",\"2536\":\"2\",\"2537\":\"5\",\"2538\":\"2\",\"2539\":\"\\\"\",\"2540\":\":\",\"2541\":\"\\\"\",\"2542\":\":\",\"2543\":\"\\\"\",\"2544\":\",\",\"2545\":\"\\\"\",\"2546\":\"2\",\"2547\":\"5\",\"2548\":\"3\",\"2549\":\"\\\"\",\"2550\":\":\",\"2551\":\"\\\"\",\"2552\":\"\\\\\",\"2553\":\"\\\"\",\"2554\":\"\\\"\",\"2555\":\",\",\"2556\":\"\\\"\",\"2557\":\"2\",\"2558\":\"5\",\"2559\":\"4\",\"2560\":\"\\\"\",\"2561\":\":\",\"2562\":\"\\\"\",\"2563\":\"l\",\"2564\":\"\\\"\",\"2565\":\",\",\"2566\":\"\\\"\",\"2567\":\"2\",\"2568\":\"5\",\"2569\":\"5\",\"2570\":\"\\\"\",\"2571\":\":\",\"2572\":\"\\\"\",\"2573\":\"\\\\\",\"2574\":\"\\\"\",\"2575\":\"\\\"\",\"2576\":\",\",\"2577\":\"\\\"\",\"2578\":\"2\",\"2579\":\"5\",\"2580\":\"6\",\"2581\":\"\\\"\",\"2582\":\":\",\"2583\":\"\\\"\",\"2584\":\",\",\"2585\":\"\\\"\",\"2586\":\",\",\"2587\":\"\\\"\",\"2588\":\"2\",\"2589\":\"5\",\"2590\":\"7\",\"2591\":\"\\\"\",\"2592\":\":\",\"2593\":\"\\\"\",\"2594\":\"\\\\\",\"2595\":\"\\\"\",\"2596\":\"\\\"\",\"2597\":\",\",\"2598\":\"\\\"\",\"2599\":\"2\",\"2600\":\"5\",\"2601\":\"8\",\"2602\":\"\\\"\",\"2603\":\":\",\"2604\":\"\\\"\",\"2605\":\"2\",\"2606\":\"\\\"\",\"2607\":\",\",\"2608\":\"\\\"\",\"2609\":\"2\",\"2610\":\"5\",\"2611\":\"9\",\"2612\":\"\\\"\",\"2613\":\":\",\"2614\":\"\\\"\",\"2615\":\"9\",\"2616\":\"\\\"\",\"2617\":\",\",\"2618\":\"\\\"\",\"2619\":\"2\",\"2620\":\"6\",\"2621\":\"0\",\"2622\":\"\\\"\",\"2623\":\":\",\"2624\":\"\\\"\",\"2625\":\"\\\\\",\"2626\":\"\\\"\",\"2627\":\"\\\"\",\"2628\":\",\",\"2629\":\"\\\"\",\"2630\":\"2\",\"2631\":\"6\",\"2632\":\"1\",\"2633\":\"\\\"\",\"2634\":\":\",\"2635\":\"\\\"\",\"2636\":\":\",\"2637\":\"\\\"\",\"2638\":\",\",\"2639\":\"\\\"\",\"2640\":\"2\",\"2641\":\"6\",\"2642\":\"2\",\"2643\":\"\\\"\",\"2644\":\":\",\"2645\":\"\\\"\",\"2646\":\"\\\\\",\"2647\":\"\\\"\",\"2648\":\"\\\"\",\"2649\":\",\",\"2650\":\"\\\"\",\"2651\":\"2\",\"2652\":\"6\",\"2653\":\"3\",\"2654\":\"\\\"\",\"2655\":\":\",\"2656\":\"\\\"\",\"2657\":\"o\",\"2658\":\"\\\"\",\"2659\":\",\",\"2660\":\"\\\"\",\"2661\":\"2\",\"2662\":\"6\",\"2663\":\"4\",\"2664\":\"\\\"\",\"2665\":\":\",\"2666\":\"\\\"\",\"2667\":\"\\\\\",\"2668\":\"\\\"\",\"2669\":\"\\\"\",\"2670\":\",\",\"2671\":\"\\\"\",\"2672\":\"2\",\"2673\":\"6\",\"2674\":\"5\",\"2675\":\"\\\"\",\"2676\":\":\",\"2677\":\"\\\"\",\"2678\":\",\",\"2679\":\"\\\"\",\"2680\":\",\",\"2681\":\"\\\"\",\"2682\":\"2\",\"2683\":\"6\",\"2684\":\"6\",\"2685\":\"\\\"\",\"2686\":\":\",\"2687\":\"\\\"\",\"2688\":\"\\\\\",\"2689\":\"\\\"\",\"2690\":\"\\\"\",\"2691\":\",\",\"2692\":\"\\\"\",\"2693\":\"2\",\"2694\":\"6\",\"2695\":\"7\",\"2696\":\"\\\"\",\"2697\":\":\",\"2698\":\"\\\"\",\"2699\":\"3\",\"2700\":\"\\\"\",\"2701\":\",\",\"2702\":\"\\\"\",\"2703\":\"2\",\"2704\":\"6\",\"2705\":\"8\",\"2706\":\"\\\"\",\"2707\":\":\",\"2708\":\"\\\"\",\"2709\":\"0\",\"2710\":\"\\\"\",\"2711\":\",\",\"2712\":\"\\\"\",\"2713\":\"2\",\"2714\":\"6\",\"2715\":\"9\",\"2716\":\"\\\"\",\"2717\":\":\",\"2718\":\"\\\"\",\"2719\":\"\\\\\",\"2720\":\"\\\"\",\"2721\":\"\\\"\",\"2722\":\",\",\"2723\":\"\\\"\",\"2724\":\"2\",\"2725\":\"7\",\"2726\":\"0\",\"2727\":\"\\\"\",\"2728\":\":\",\"2729\":\"\\\"\",\"2730\":\":\",\"2731\":\"\\\"\",\"2732\":\",\",\"2733\":\"\\\"\",\"2734\":\"2\",\"2735\":\"7\",\"2736\":\"1\",\"2737\":\"\\\"\",\"2738\":\":\",\"2739\":\"\\\"\",\"2740\":\"\\\\\",\"2741\":\"\\\"\",\"2742\":\"\\\"\",\"2743\":\",\",\"2744\":\"\\\"\",\"2745\":\"2\",\"2746\":\"7\",\"2747\":\"2\",\"2748\":\"\\\"\",\"2749\":\":\",\"2750\":\"\\\"\",\"2751\":\"c\",\"2752\":\"\\\"\",\"2753\":\",\",\"2754\":\"\\\"\",\"2755\":\"2\",\"2756\":\"7\",\"2757\":\"3\",\"2758\":\"\\\"\",\"2759\":\":\",\"2760\":\"\\\"\",\"2761\":\"\\\\\",\"2762\":\"\\\"\",\"2763\":\"\\\"\",\"2764\":\",\",\"2765\":\"\\\"\",\"2766\":\"2\",\"2767\":\"7\",\"2768\":\"4\",\"2769\":\"\\\"\",\"2770\":\":\",\"2771\":\"\\\"\",\"2772\":\",\",\"2773\":\"\\\"\",\"2774\":\",\",\"2775\":\"\\\"\",\"2776\":\"2\",\"2777\":\"7\",\"2778\":\"5\",\"2779\":\"\\\"\",\"2780\":\":\",\"2781\":\"\\\"\",\"2782\":\"\\\\\",\"2783\":\"\\\"\",\"2784\":\"\\\"\",\"2785\":\",\",\"2786\":\"\\\"\",\"2787\":\"2\",\"2788\":\"7\",\"2789\":\"6\",\"2790\":\"\\\"\",\"2791\":\":\",\"2792\":\"\\\"\",\"2793\":\"3\",\"2794\":\"\\\"\",\"2795\":\",\",\"2796\":\"\\\"\",\"2797\":\"2\",\"2798\":\"7\",\"2799\":\"7\",\"2800\":\"\\\"\",\"2801\":\":\",\"2802\":\"\\\"\",\"2803\":\"1\",\"2804\":\"\\\"\",\"2805\":\",\",\"2806\":\"\\\"\",\"2807\":\"2\",\"2808\":\"7\",\"2809\":\"8\",\"2810\":\"\\\"\",\"2811\":\":\",\"2812\":\"\\\"\",\"2813\":\"\\\\\",\"2814\":\"\\\"\",\"2815\":\"\\\"\",\"2816\":\",\",\"2817\":\"\\\"\",\"2818\":\"2\",\"2819\":\"7\",\"2820\":\"9\",\"2821\":\"\\\"\",\"2822\":\":\",\"2823\":\"\\\"\",\"2824\":\":\",\"2825\":\"\\\"\",\"2826\":\",\",\"2827\":\"\\\"\",\"2828\":\"2\",\"2829\":\"8\",\"2830\":\"0\",\"2831\":\"\\\"\",\"2832\":\":\",\"2833\":\"\\\"\",\"2834\":\"\\\\\",\"2835\":\"\\\"\",\"2836\":\"\\\"\",\"2837\":\",\",\"2838\":\"\\\"\",\"2839\":\"2\",\"2840\":\"8\",\"2841\":\"1\",\"2842\":\"\\\"\",\"2843\":\":\",\"2844\":\"\\\"\",\"2845\":\"a\",\"2846\":\"\\\"\",\"2847\":\",\",\"2848\":\"\\\"\",\"2849\":\"2\",\"2850\":\"8\",\"2851\":\"2\",\"2852\":\"\\\"\",\"2853\":\":\",\"2854\":\"\\\"\",\"2855\":\"\\\\\",\"2856\":\"\\\"\",\"2857\":\"\\\"\",\"2858\":\",\",\"2859\":\"\\\"\",\"2860\":\"2\",\"2861\":\"8\",\"2862\":\"3\",\"2863\":\"\\\"\",\"2864\":\":\",\"2865\":\"\\\"\",\"2866\":\",\",\"2867\":\"\\\"\",\"2868\":\",\",\"2869\":\"\\\"\",\"2870\":\"2\",\"2871\":\"8\",\"2872\":\"4\",\"2873\":\"\\\"\",\"2874\":\":\",\"2875\":\"\\\"\",\"2876\":\"\\\\\",\"2877\":\"\\\"\",\"2878\":\"\\\"\",\"2879\":\",\",\"2880\":\"\\\"\",\"2881\":\"2\",\"2882\":\"8\",\"2883\":\"5\",\"2884\":\"\\\"\",\"2885\":\":\",\"2886\":\"\\\"\",\"2887\":\"3\",\"2888\":\"\\\"\",\"2889\":\",\",\"2890\":\"\\\"\",\"2891\":\"2\",\"2892\":\"8\",\"2893\":\"6\",\"2894\":\"\\\"\",\"2895\":\":\",\"2896\":\"\\\"\",\"2897\":\"2\",\"2898\":\"\\\"\",\"2899\":\",\",\"2900\":\"\\\"\",\"2901\":\"2\",\"2902\":\"8\",\"2903\":\"7\",\"2904\":\"\\\"\",\"2905\":\":\",\"2906\":\"\\\"\",\"2907\":\"\\\\\",\"2908\":\"\\\"\",\"2909\":\"\\\"\",\"2910\":\",\",\"2911\":\"\\\"\",\"2912\":\"2\",\"2913\":\"8\",\"2914\":\"8\",\"2915\":\"\\\"\",\"2916\":\":\",\"2917\":\"\\\"\",\"2918\":\":\",\"2919\":\"\\\"\",\"2920\":\",\",\"2921\":\"\\\"\",\"2922\":\"2\",\"2923\":\"8\",\"2924\":\"9\",\"2925\":\"\\\"\",\"2926\":\":\",\"2927\":\"\\\"\",\"2928\":\"\\\\\",\"2929\":\"\\\"\",\"2930\":\"\\\"\",\"2931\":\",\",\"2932\":\"\\\"\",\"2933\":\"2\",\"2934\":\"9\",\"2935\":\"0\",\"2936\":\"\\\"\",\"2937\":\":\",\"2938\":\"\\\"\",\"2939\":\"l\",\"2940\":\"\\\"\",\"2941\":\",\",\"2942\":\"\\\"\",\"2943\":\"2\",\"2944\":\"9\",\"2945\":\"1\",\"2946\":\"\\\"\",\"2947\":\":\",\"2948\":\"\\\"\",\"2949\":\"\\\\\",\"2950\":\"\\\"\",\"2951\":\"\\\"\",\"2952\":\",\",\"2953\":\"\\\"\",\"2954\":\"2\",\"2955\":\"9\",\"2956\":\"2\",\"2957\":\"\\\"\",\"2958\":\":\",\"2959\":\"\\\"\",\"2960\":\",\",\"2961\":\"\\\"\",\"2962\":\",\",\"2963\":\"\\\"\",\"2964\":\"2\",\"2965\":\"9\",\"2966\":\"3\",\"2967\":\"\\\"\",\"2968\":\":\",\"2969\":\"\\\"\",\"2970\":\"\\\\\",\"2971\":\"\\\"\",\"2972\":\"\\\"\",\"2973\":\",\",\"2974\":\"\\\"\",\"2975\":\"2\",\"2976\":\"9\",\"2977\":\"4\",\"2978\":\"\\\"\",\"2979\":\":\",\"2980\":\"\\\"\",\"2981\":\"3\",\"2982\":\"\\\"\",\"2983\":\",\",\"2984\":\"\\\"\",\"2985\":\"2\",\"2986\":\"9\",\"2987\":\"5\",\"2988\":\"\\\"\",\"2989\":\":\",\"2990\":\"\\\"\",\"2991\":\"3\",\"2992\":\"\\\"\",\"2993\":\",\",\"2994\":\"\\\"\",\"2995\":\"2\",\"2996\":\"9\",\"2997\":\"6\",\"2998\":\"\\\"\",\"2999\":\":\",\"3000\":\"\\\"\",\"3001\":\"\\\\\",\"3002\":\"\\\"\",\"3003\":\"\\\"\",\"3004\":\",\",\"3005\":\"\\\"\",\"3006\":\"2\",\"3007\":\"9\",\"3008\":\"7\",\"3009\":\"\\\"\",\"3010\":\":\",\"3011\":\"\\\"\",\"3012\":\":\",\"3013\":\"\\\"\",\"3014\":\",\",\"3015\":\"\\\"\",\"3016\":\"2\",\"3017\":\"9\",\"3018\":\"8\",\"3019\":\"\\\"\",\"3020\":\":\",\"3021\":\"\\\"\",\"3022\":\"\\\\\",\"3023\":\"\\\"\",\"3024\":\"\\\"\",\"3025\":\",\",\"3026\":\"\\\"\",\"3027\":\"2\",\"3028\":\"9\",\"3029\":\"9\",\"3030\":\"\\\"\",\"3031\":\":\",\"3032\":\"\\\"\",\"3033\":\"e\",\"3034\":\"\\\"\",\"3035\":\",\",\"3036\":\"\\\"\",\"3037\":\"3\",\"3038\":\"0\",\"3039\":\"0\",\"3040\":\"\\\"\",\"3041\":\":\",\"3042\":\"\\\"\",\"3043\":\"\\\\\",\"3044\":\"\\\"\",\"3045\":\"\\\"\",\"3046\":\",\",\"3047\":\"\\\"\",\"3048\":\"3\",\"3049\":\"0\",\"3050\":\"1\",\"3051\":\"\\\"\",\"3052\":\":\",\"3053\":\"\\\"\",\"3054\":\",\",\"3055\":\"\\\"\",\"3056\":\",\",\"3057\":\"\\\"\",\"3058\":\"3\",\"3059\":\"0\",\"3060\":\"2\",\"3061\":\"\\\"\",\"3062\":\":\",\"3063\":\"\\\"\",\"3064\":\"\\\\\",\"3065\":\"\\\"\",\"3066\":\"\\\"\",\"3067\":\",\",\"3068\":\"\\\"\",\"3069\":\"3\",\"3070\":\"0\",\"3071\":\"3\",\"3072\":\"\\\"\",\"3073\":\":\",\"3074\":\"\\\"\",\"3075\":\"3\",\"3076\":\"\\\"\",\"3077\":\",\",\"3078\":\"\\\"\",\"3079\":\"3\",\"3080\":\"0\",\"3081\":\"4\",\"3082\":\"\\\"\",\"3083\":\":\",\"3084\":\"\\\"\",\"3085\":\"4\",\"3086\":\"\\\"\",\"3087\":\",\",\"3088\":\"\\\"\",\"3089\":\"3\",\"3090\":\"0\",\"3091\":\"5\",\"3092\":\"\\\"\",\"3093\":\":\",\"3094\":\"\\\"\",\"3095\":\"\\\\\",\"3096\":\"\\\"\",\"3097\":\"\\\"\",\"3098\":\",\",\"3099\":\"\\\"\",\"3100\":\"3\",\"3101\":\"0\",\"3102\":\"6\",\"3103\":\"\\\"\",\"3104\":\":\",\"3105\":\"\\\"\",\"3106\":\":\",\"3107\":\"\\\"\",\"3108\":\",\",\"3109\":\"\\\"\",\"3110\":\"3\",\"3111\":\"0\",\"3112\":\"7\",\"3113\":\"\\\"\",\"3114\":\":\",\"3115\":\"\\\"\",\"3116\":\"\\\\\",\"3117\":\"\\\"\",\"3118\":\"\\\"\",\"3119\":\",\",\"3120\":\"\\\"\",\"3121\":\"3\",\"3122\":\"0\",\"3123\":\"8\",\"3124\":\"\\\"\",\"3125\":\":\",\"3126\":\"\\\"\",\"3127\":\"\\\\\",\"3128\":\"\\\\\",\"3129\":\"\\\"\",\"3130\":\",\",\"3131\":\"\\\"\",\"3132\":\"3\",\"3133\":\"0\",\"3134\":\"9\",\"3135\":\"\\\"\",\"3136\":\":\",\"3137\":\"\\\"\",\"3138\":\"\\\\\",\"3139\":\"\\\"\",\"3140\":\"\\\"\",\"3141\":\",\",\"3142\":\"\\\"\",\"3143\":\"3\",\"3144\":\"1\",\"3145\":\"0\",\"3146\":\"\\\"\",\"3147\":\":\",\"3148\":\"\\\"\",\"3149\":\"\\\\\",\"3150\":\"\\\"\",\"3151\":\"\\\"\",\"3152\":\",\",\"3153\":\"\\\"\",\"3154\":\"3\",\"3155\":\"1\",\"3156\":\"1\",\"3157\":\"\\\"\",\"3158\":\":\",\"3159\":\"\\\"\",\"3160\":\",\",\"3161\":\"\\\"\",\"3162\":\",\",\"3163\":\"\\\"\",\"3164\":\"3\",\"3165\":\"1\",\"3166\":\"2\",\"3167\":\"\\\"\",\"3168\":\":\",\"3169\":\"\\\"\",\"3170\":\"\\\\\",\"3171\":\"\\\"\",\"3172\":\"\\\"\",\"3173\":\",\",\"3174\":\"\\\"\",\"3175\":\"3\",\"3176\":\"1\",\"3177\":\"3\",\"3178\":\"\\\"\",\"3179\":\":\",\"3180\":\"\\\"\",\"3181\":\"3\",\"3182\":\"\\\"\",\"3183\":\",\",\"3184\":\"\\\"\",\"3185\":\"3\",\"3186\":\"1\",\"3187\":\"4\",\"3188\":\"\\\"\",\"3189\":\":\",\"3190\":\"\\\"\",\"3191\":\"5\",\"3192\":\"\\\"\",\"3193\":\",\",\"3194\":\"\\\"\",\"3195\":\"3\",\"3196\":\"1\",\"3197\":\"5\",\"3198\":\"\\\"\",\"3199\":\":\",\"3200\":\"\\\"\",\"3201\":\"\\\\\",\"3202\":\"\\\"\",\"3203\":\"\\\"\",\"3204\":\",\",\"3205\":\"\\\"\",\"3206\":\"3\",\"3207\":\"1\",\"3208\":\"6\",\"3209\":\"\\\"\",\"3210\":\":\",\"3211\":\"\\\"\",\"3212\":\":\",\"3213\":\"\\\"\",\"3214\":\",\",\"3215\":\"\\\"\",\"3216\":\"3\",\"3217\":\"1\",\"3218\":\"7\",\"3219\":\"\\\"\",\"3220\":\":\",\"3221\":\"\\\"\",\"3222\":\"\\\\\",\"3223\":\"\\\"\",\"3224\":\"\\\"\",\"3225\":\",\",\"3226\":\"\\\"\",\"3227\":\"3\",\"3228\":\"1\",\"3229\":\"8\",\"3230\":\"\\\"\",\"3231\":\":\",\"3232\":\"\\\"\",\"3233\":\":\",\"3234\":\"\\\"\",\"3235\":\",\",\"3236\":\"\\\"\",\"3237\":\"3\",\"3238\":\"1\",\"3239\":\"9\",\"3240\":\"\\\"\",\"3241\":\":\",\"3242\":\"\\\"\",\"3243\":\"\\\\\",\"3244\":\"\\\"\",\"3245\":\"\\\"\",\"3246\":\",\",\"3247\":\"\\\"\",\"3248\":\"3\",\"3249\":\"2\",\"3250\":\"0\",\"3251\":\"\\\"\",\"3252\":\":\",\"3253\":\"\\\"\",\"3254\":\",\",\"3255\":\"\\\"\",\"3256\":\",\",\"3257\":\"\\\"\",\"3258\":\"3\",\"3259\":\"2\",\"3260\":\"1\",\"3261\":\"\\\"\",\"3262\":\":\",\"3263\":\"\\\"\",\"3264\":\"\\\\\",\"3265\":\"\\\"\",\"3266\":\"\\\"\",\"3267\":\",\",\"3268\":\"\\\"\",\"3269\":\"3\",\"3270\":\"2\",\"3271\":\"2\",\"3272\":\"\\\"\",\"3273\":\":\",\"3274\":\"\\\"\",\"3275\":\"3\",\"3276\":\"\\\"\",\"3277\":\",\",\"3278\":\"\\\"\",\"3279\":\"3\",\"3280\":\"2\",\"3281\":\"3\",\"3282\":\"\\\"\",\"3283\":\":\",\"3284\":\"\\\"\",\"3285\":\"6\",\"3286\":\"\\\"\",\"3287\":\",\",\"3288\":\"\\\"\",\"3289\":\"3\",\"3290\":\"2\",\"3291\":\"4\",\"3292\":\"\\\"\",\"3293\":\":\",\"3294\":\"\\\"\",\"3295\":\"\\\\\",\"3296\":\"\\\"\",\"3297\":\"\\\"\",\"3298\":\",\",\"3299\":\"\\\"\",\"3300\":\"3\",\"3301\":\"2\",\"3302\":\"5\",\"3303\":\"\\\"\",\"3304\":\":\",\"3305\":\"\\\"\",\"3306\":\":\",\"3307\":\"\\\"\",\"3308\":\",\",\"3309\":\"\\\"\",\"3310\":\"3\",\"3311\":\"2\",\"3312\":\"6\",\"3313\":\"\\\"\",\"3314\":\":\",\"3315\":\"\\\"\",\"3316\":\"\\\\\",\"3317\":\"\\\"\",\"3318\":\"\\\"\",\"3319\":\",\",\"3320\":\"\\\"\",\"3321\":\"3\",\"3322\":\"2\",\"3323\":\"7\",\"3324\":\"\\\"\",\"3325\":\":\",\"3326\":\"\\\"\",\"3327\":\"\\\\\",\"3328\":\"\\\\\",\"3329\":\"\\\"\",\"3330\":\",\",\"3331\":\"\\\"\",\"3332\":\"3\",\"3333\":\"2\",\"3334\":\"8\",\"3335\":\"\\\"\",\"3336\":\":\",\"3337\":\"\\\"\",\"3338\":\"\\\\\",\"3339\":\"\\\"\",\"3340\":\"\\\"\",\"3341\":\",\",\"3342\":\"\\\"\",\"3343\":\"3\",\"3344\":\"2\",\"3345\":\"9\",\"3346\":\"\\\"\",\"3347\":\":\",\"3348\":\"\\\"\",\"3349\":\"\\\\\",\"3350\":\"\\\"\",\"3351\":\"\\\"\",\"3352\":\",\",\"3353\":\"\\\"\",\"3354\":\"3\",\"3355\":\"3\",\"3356\":\"0\",\"3357\":\"\\\"\",\"3358\":\":\",\"3359\":\"\\\"\",\"3360\":\",\",\"3361\":\"\\\"\",\"3362\":\",\",\"3363\":\"\\\"\",\"3364\":\"3\",\"3365\":\"3\",\"3366\":\"1\",\"3367\":\"\\\"\",\"3368\":\":\",\"3369\":\"\\\"\",\"3370\":\"\\\\\",\"3371\":\"\\\"\",\"3372\":\"\\\"\",\"3373\":\",\",\"3374\":\"\\\"\",\"3375\":\"3\",\"3376\":\"3\",\"3377\":\"2\",\"3378\":\"\\\"\",\"3379\":\":\",\"3380\":\"\\\"\",\"3381\":\"3\",\"3382\":\"\\\"\",\"3383\":\",\",\"3384\":\"\\\"\",\"3385\":\"3\",\"3386\":\"3\",\"3387\":\"3\",\"3388\":\"\\\"\",\"3389\":\":\",\"3390\":\"\\\"\",\"3391\":\"7\",\"3392\":\"\\\"\",\"3393\":\",\",\"3394\":\"\\\"\",\"3395\":\"3\",\"3396\":\"3\",\"3397\":\"4\",\"3398\":\"\\\"\",\"3399\":\":\",\"3400\":\"\\\"\",\"3401\":\"\\\\\",\"3402\":\"\\\"\",\"3403\":\"\\\"\",\"3404\":\",\",\"3405\":\"\\\"\",\"3406\":\"3\",\"3407\":\"3\",\"3408\":\"5\",\"3409\":\"\\\"\",\"3410\":\":\",\"3411\":\"\\\"\",\"3412\":\":\",\"3413\":\"\\\"\",\"3414\":\",\",\"3415\":\"\\\"\",\"3416\":\"3\",\"3417\":\"3\",\"3418\":\"6\",\"3419\":\"\\\"\",\"3420\":\":\",\"3421\":\"\\\"\",\"3422\":\"\\\\\",\"3423\":\"\\\"\",\"3424\":\"\\\"\",\"3425\":\",\",\"3426\":\"\\\"\",\"3427\":\"3\",\"3428\":\"3\",\"3429\":\"7\",\"3430\":\"\\\"\",\"3431\":\":\",\"3432\":\"\\\"\",\"3433\":\"e\",\"3434\":\"\\\"\",\"3435\":\",\",\"3436\":\"\\\"\",\"3437\":\"3\",\"3438\":\"3\",\"3439\":\"8\",\"3440\":\"\\\"\",\"3441\":\":\",\"3442\":\"\\\"\",\"3443\":\"\\\\\",\"3444\":\"\\\"\",\"3445\":\"\\\"\",\"3446\":\",\",\"3447\":\"\\\"\",\"3448\":\"3\",\"3449\":\"3\",\"3450\":\"9\",\"3451\":\"\\\"\",\"3452\":\":\",\"3453\":\"\\\"\",\"3454\":\",\",\"3455\":\"\\\"\",\"3456\":\",\",\"3457\":\"\\\"\",\"3458\":\"3\",\"3459\":\"4\",\"3460\":\"0\",\"3461\":\"\\\"\",\"3462\":\":\",\"3463\":\"\\\"\",\"3464\":\"\\\\\",\"3465\":\"\\\"\",\"3466\":\"\\\"\",\"3467\":\",\",\"3468\":\"\\\"\",\"3469\":\"3\",\"3470\":\"4\",\"3471\":\"1\",\"3472\":\"\\\"\",\"3473\":\":\",\"3474\":\"\\\"\",\"3475\":\"3\",\"3476\":\"\\\"\",\"3477\":\",\",\"3478\":\"\\\"\",\"3479\":\"3\",\"3480\":\"4\",\"3481\":\"2\",\"3482\":\"\\\"\",\"3483\":\":\",\"3484\":\"\\\"\",\"3485\":\"8\",\"3486\":\"\\\"\",\"3487\":\",\",\"3488\":\"\\\"\",\"3489\":\"3\",\"3490\":\"4\",\"3491\":\"3\",\"3492\":\"\\\"\",\"3493\":\":\",\"3494\":\"\\\"\",\"3495\":\"\\\\\",\"3496\":\"\\\"\",\"3497\":\"\\\"\",\"3498\":\",\",\"3499\":\"\\\"\",\"3500\":\"3\",\"3501\":\"4\",\"3502\":\"4\",\"3503\":\"\\\"\",\"3504\":\":\",\"3505\":\"\\\"\",\"3506\":\":\",\"3507\":\"\\\"\",\"3508\":\",\",\"3509\":\"\\\"\",\"3510\":\"3\",\"3511\":\"4\",\"3512\":\"5\",\"3513\":\"\\\"\",\"3514\":\":\",\"3515\":\"\\\"\",\"3516\":\"\\\\\",\"3517\":\"\\\"\",\"3518\":\"\\\"\",\"3519\":\",\",\"3520\":\"\\\"\",\"3521\":\"3\",\"3522\":\"4\",\"3523\":\"6\",\"3524\":\"\\\"\",\"3525\":\":\",\"3526\":\"\\\"\",\"3527\":\"n\",\"3528\":\"\\\"\",\"3529\":\",\",\"3530\":\"\\\"\",\"3531\":\"3\",\"3532\":\"4\",\"3533\":\"7\",\"3534\":\"\\\"\",\"3535\":\":\",\"3536\":\"\\\"\",\"3537\":\"\\\\\",\"3538\":\"\\\"\",\"3539\":\"\\\"\",\"3540\":\",\",\"3541\":\"\\\"\",\"3542\":\"3\",\"3543\":\"4\",\"3544\":\"8\",\"3545\":\"\\\"\",\"3546\":\":\",\"3547\":\"\\\"\",\"3548\":\",\",\"3549\":\"\\\"\",\"3550\":\",\",\"3551\":\"\\\"\",\"3552\":\"3\",\"3553\":\"4\",\"3554\":\"9\",\"3555\":\"\\\"\",\"3556\":\":\",\"3557\":\"\\\"\",\"3558\":\"\\\\\",\"3559\":\"\\\"\",\"3560\":\"\\\"\",\"3561\":\",\",\"3562\":\"\\\"\",\"3563\":\"3\",\"3564\":\"5\",\"3565\":\"0\",\"3566\":\"\\\"\",\"3567\":\":\",\"3568\":\"\\\"\",\"3569\":\"3\",\"3570\":\"\\\"\",\"3571\":\",\",\"3572\":\"\\\"\",\"3573\":\"3\",\"3574\":\"5\",\"3575\":\"1\",\"3576\":\"\\\"\",\"3577\":\":\",\"3578\":\"\\\"\",\"3579\":\"9\",\"3580\":\"\\\"\",\"3581\":\",\",\"3582\":\"\\\"\",\"3583\":\"3\",\"3584\":\"5\",\"3585\":\"2\",\"3586\":\"\\\"\",\"3587\":\":\",\"3588\":\"\\\"\",\"3589\":\"\\\\\",\"3590\":\"\\\"\",\"3591\":\"\\\"\",\"3592\":\",\",\"3593\":\"\\\"\",\"3594\":\"3\",\"3595\":\"5\",\"3596\":\"3\",\"3597\":\"\\\"\",\"3598\":\":\",\"3599\":\"\\\"\",\"3600\":\":\",\"3601\":\"\\\"\",\"3602\":\",\",\"3603\":\"\\\"\",\"3604\":\"3\",\"3605\":\"5\",\"3606\":\"4\",\"3607\":\"\\\"\",\"3608\":\":\",\"3609\":\"\\\"\",\"3610\":\"\\\\\",\"3611\":\"\\\"\",\"3612\":\"\\\"\",\"3613\":\",\",\"3614\":\"\\\"\",\"3615\":\"3\",\"3616\":\"5\",\"3617\":\"5\",\"3618\":\"\\\"\",\"3619\":\":\",\"3620\":\"\\\"\",\"3621\":\"-\",\"3622\":\"\\\"\",\"3623\":\",\",\"3624\":\"\\\"\",\"3625\":\"3\",\"3626\":\"5\",\"3627\":\"6\",\"3628\":\"\\\"\",\"3629\":\":\",\"3630\":\"\\\"\",\"3631\":\"\\\\\",\"3632\":\"\\\"\",\"3633\":\"\\\"\",\"3634\":\",\",\"3635\":\"\\\"\",\"3636\":\"3\",\"3637\":\"5\",\"3638\":\"7\",\"3639\":\"\\\"\",\"3640\":\":\",\"3641\":\"\\\"\",\"3642\":\",\",\"3643\":\"\\\"\",\"3644\":\",\",\"3645\":\"\\\"\",\"3646\":\"3\",\"3647\":\"5\",\"3648\":\"8\",\"3649\":\"\\\"\",\"3650\":\":\",\"3651\":\"\\\"\",\"3652\":\"\\\\\",\"3653\":\"\\\"\",\"3654\":\"\\\"\",\"3655\":\",\",\"3656\":\"\\\"\",\"3657\":\"3\",\"3658\":\"5\",\"3659\":\"9\",\"3660\":\"\\\"\",\"3661\":\":\",\"3662\":\"\\\"\",\"3663\":\"4\",\"3664\":\"\\\"\",\"3665\":\",\",\"3666\":\"\\\"\",\"3667\":\"3\",\"3668\":\"6\",\"3669\":\"0\",\"3670\":\"\\\"\",\"3671\":\":\",\"3672\":\"\\\"\",\"3673\":\"0\",\"3674\":\"\\\"\",\"3675\":\",\",\"3676\":\"\\\"\",\"3677\":\"3\",\"3678\":\"6\",\"3679\":\"1\",\"3680\":\"\\\"\",\"3681\":\":\",\"3682\":\"\\\"\",\"3683\":\"\\\\\",\"3684\":\"\\\"\",\"3685\":\"\\\"\",\"3686\":\",\",\"3687\":\"\\\"\",\"3688\":\"3\",\"3689\":\"6\",\"3690\":\"2\",\"3691\":\"\\\"\",\"3692\":\":\",\"3693\":\"\\\"\",\"3694\":\":\",\"3695\":\"\\\"\",\"3696\":\",\",\"3697\":\"\\\"\",\"3698\":\"3\",\"3699\":\"6\",\"3700\":\"3\",\"3701\":\"\\\"\",\"3702\":\":\",\"3703\":\"\\\"\",\"3704\":\"\\\\\",\"3705\":\"\\\"\",\"3706\":\"\\\"\",\"3707\":\",\",\"3708\":\"\\\"\",\"3709\":\"3\",\"3710\":\"6\",\"3711\":\"4\",\"3712\":\"\\\"\",\"3713\":\":\",\"3714\":\"\\\"\",\"3715\":\"I\",\"3716\":\"\\\"\",\"3717\":\",\",\"3718\":\"\\\"\",\"3719\":\"3\",\"3720\":\"6\",\"3721\":\"5\",\"3722\":\"\\\"\",\"3723\":\":\",\"3724\":\"\\\"\",\"3725\":\"\\\\\",\"3726\":\"\\\"\",\"3727\":\"\\\"\",\"3728\":\",\",\"3729\":\"\\\"\",\"3730\":\"3\",\"3731\":\"6\",\"3732\":\"6\",\"3733\":\"\\\"\",\"3734\":\":\",\"3735\":\"\\\"\",\"3736\":\",\",\"3737\":\"\\\"\",\"3738\":\",\",\"3739\":\"\\\"\",\"3740\":\"3\",\"3741\":\"6\",\"3742\":\"7\",\"3743\":\"\\\"\",\"3744\":\":\",\"3745\":\"\\\"\",\"3746\":\"\\\\\",\"3747\":\"\\\"\",\"3748\":\"\\\"\",\"3749\":\",\",\"3750\":\"\\\"\",\"3751\":\"3\",\"3752\":\"6\",\"3753\":\"8\",\"3754\":\"\\\"\",\"3755\":\":\",\"3756\":\"\\\"\",\"3757\":\"4\",\"3758\":\"\\\"\",\"3759\":\",\",\"3760\":\"\\\"\",\"3761\":\"3\",\"3762\":\"6\",\"3763\":\"9\",\"3764\":\"\\\"\",\"3765\":\":\",\"3766\":\"\\\"\",\"3767\":\"1\",\"3768\":\"\\\"\",\"3769\":\",\",\"3770\":\"\\\"\",\"3771\":\"3\",\"3772\":\"7\",\"3773\":\"0\",\"3774\":\"\\\"\",\"3775\":\":\",\"3776\":\"\\\"\",\"3777\":\"\\\\\",\"3778\":\"\\\"\",\"3779\":\"\\\"\",\"3780\":\",\",\"3781\":\"\\\"\",\"3782\":\"3\",\"3783\":\"7\",\"3784\":\"1\",\"3785\":\"\\\"\",\"3786\":\":\",\"3787\":\"\\\"\",\"3788\":\":\",\"3789\":\"\\\"\",\"3790\":\",\",\"3791\":\"\\\"\",\"3792\":\"3\",\"3793\":\"7\",\"3794\":\"2\",\"3795\":\"\\\"\",\"3796\":\":\",\"3797\":\"\\\"\",\"3798\":\"\\\\\",\"3799\":\"\\\"\",\"3800\":\"\\\"\",\"3801\":\",\",\"3802\":\"\\\"\",\"3803\":\"3\",\"3804\":\"7\",\"3805\":\"3\",\"3806\":\"\\\"\",\"3807\":\":\",\"3808\":\"\\\"\",\"3809\":\"N\",\"3810\":\"\\\"\",\"3811\":\",\",\"3812\":\"\\\"\",\"3813\":\"3\",\"3814\":\"7\",\"3815\":\"4\",\"3816\":\"\\\"\",\"3817\":\":\",\"3818\":\"\\\"\",\"3819\":\"\\\\\",\"3820\":\"\\\"\",\"3821\":\"\\\"\",\"3822\":\",\",\"3823\":\"\\\"\",\"3824\":\"3\",\"3825\":\"7\",\"3826\":\"5\",\"3827\":\"\\\"\",\"3828\":\":\",\"3829\":\"\\\"\",\"3830\":\",\",\"3831\":\"\\\"\",\"3832\":\",\",\"3833\":\"\\\"\",\"3834\":\"3\",\"3835\":\"7\",\"3836\":\"6\",\"3837\":\"\\\"\",\"3838\":\":\",\"3839\":\"\\\"\",\"3840\":\"\\\\\",\"3841\":\"\\\"\",\"3842\":\"\\\"\",\"3843\":\",\",\"3844\":\"\\\"\",\"3845\":\"3\",\"3846\":\"7\",\"3847\":\"7\",\"3848\":\"\\\"\",\"3849\":\":\",\"3850\":\"\\\"\",\"3851\":\"4\",\"3852\":\"\\\"\",\"3853\":\",\",\"3854\":\"\\\"\",\"3855\":\"3\",\"3856\":\"7\",\"3857\":\"8\",\"3858\":\"\\\"\",\"3859\":\":\",\"3860\":\"\\\"\",\"3861\":\"2\",\"3862\":\"\\\"\",\"3863\":\",\",\"3864\":\"\\\"\",\"3865\":\"3\",\"3866\":\"7\",\"3867\":\"9\",\"3868\":\"\\\"\",\"3869\":\":\",\"3870\":\"\\\"\",\"3871\":\"\\\\\",\"3872\":\"\\\"\",\"3873\":\"\\\"\",\"3874\":\",\",\"3875\":\"\\\"\",\"3876\":\"3\",\"3877\":\"8\",\"3878\":\"0\",\"3879\":\"\\\"\",\"3880\":\":\",\"3881\":\"\\\"\",\"3882\":\":\",\"3883\":\"\\\"\",\"3884\":\",\",\"3885\":\"\\\"\",\"3886\":\"3\",\"3887\":\"8\",\"3888\":\"1\",\"3889\":\"\\\"\",\"3890\":\":\",\"3891\":\"\\\"\",\"3892\":\"\\\\\",\"3893\":\"\\\"\",\"3894\":\"\\\"\",\"3895\":\",\",\"3896\":\"\\\"\",\"3897\":\"3\",\"3898\":\"8\",\"3899\":\"2\",\"3900\":\"\\\"\",\"3901\":\":\",\"3902\":\"\\\"\",\"3903\":\"\\\\\",\"3904\":\"\\\\\",\"3905\":\"\\\"\",\"3906\":\",\",\"3907\":\"\\\"\",\"3908\":\"3\",\"3909\":\"8\",\"3910\":\"3\",\"3911\":\"\\\"\",\"3912\":\":\",\"3913\":\"\\\"\",\"3914\":\"\\\\\",\"3915\":\"\\\"\",\"3916\":\"\\\"\",\"3917\":\",\",\"3918\":\"\\\"\",\"3919\":\"3\",\"3920\":\"8\",\"3921\":\"4\",\"3922\":\"\\\"\",\"3923\":\":\",\"3924\":\"\\\"\",\"3925\":\"\\\\\",\"3926\":\"\\\"\",\"3927\":\"\\\"\",\"3928\":\",\",\"3929\":\"\\\"\",\"3930\":\"3\",\"3931\":\"8\",\"3932\":\"5\",\"3933\":\"\\\"\",\"3934\":\":\",\"3935\":\"\\\"\",\"3936\":\",\",\"3937\":\"\\\"\",\"3938\":\",\",\"3939\":\"\\\"\",\"3940\":\"3\",\"3941\":\"8\",\"3942\":\"6\",\"3943\":\"\\\"\",\"3944\":\":\",\"3945\":\"\\\"\",\"3946\":\"\\\\\",\"3947\":\"\\\"\",\"3948\":\"\\\"\",\"3949\":\",\",\"3950\":\"\\\"\",\"3951\":\"3\",\"3952\":\"8\",\"3953\":\"7\",\"3954\":\"\\\"\",\"3955\":\":\",\"3956\":\"\\\"\",\"3957\":\"4\",\"3958\":\"\\\"\",\"3959\":\",\",\"3960\":\"\\\"\",\"3961\":\"3\",\"3962\":\"8\",\"3963\":\"8\",\"3964\":\"\\\"\",\"3965\":\":\",\"3966\":\"\\\"\",\"3967\":\"3\",\"3968\":\"\\\"\",\"3969\":\",\",\"3970\":\"\\\"\",\"3971\":\"3\",\"3972\":\"8\",\"3973\":\"9\",\"3974\":\"\\\"\",\"3975\":\":\",\"3976\":\"\\\"\",\"3977\":\"\\\\\",\"3978\":\"\\\"\",\"3979\":\"\\\"\",\"3980\":\",\",\"3981\":\"\\\"\",\"3982\":\"3\",\"3983\":\"9\",\"3984\":\"0\",\"3985\":\"\\\"\",\"3986\":\":\",\"3987\":\"\\\"\",\"3988\":\":\",\"3989\":\"\\\"\",\"3990\":\",\",\"3991\":\"\\\"\",\"3992\":\"3\",\"3993\":\"9\",\"3994\":\"1\",\"3995\":\"\\\"\",\"3996\":\":\",\"3997\":\"\\\"\",\"3998\":\"\\\\\",\"3999\":\"\\\"\",\"4000\":\"\\\"\",\"4001\":\",\",\"4002\":\"\\\"\",\"4003\":\"3\",\"4004\":\"9\",\"4005\":\"2\",\"4006\":\"\\\"\",\"4007\":\":\",\"4008\":\"\\\"\",\"4009\":\"}\",\"4010\":\"\\\"\",\"4011\":\",\",\"4012\":\"\\\"\",\"4013\":\"3\",\"4014\":\"9\",\"4015\":\"3\",\"4016\":\"\\\"\",\"4017\":\":\",\"4018\":\"\\\"\",\"4019\":\"\\\\\",\"4020\":\"\\\"\",\"4021\":\"\\\"\",\"4022\":\",\",\"4023\":\"\\\"\",\"4024\":\"3\",\"4025\":\"9\",\"4026\":\"4\",\"4027\":\"\\\"\",\"4028\":\":\",\"4029\":\"\\\"\",\"4030\":\",\",\"4031\":\"\\\"\",\"4032\":\",\",\"4033\":\"\\\"\",\"4034\":\"3\",\"4035\":\"9\",\"4036\":\"5\",\"4037\":\"\\\"\",\"4038\":\":\",\"4039\":\"\\\"\",\"4040\":\"\\\\\",\"4041\":\"\\\"\",\"4042\":\"\\\"\",\"4043\":\",\",\"4044\":\"\\\"\",\"4045\":\"3\",\"4046\":\"9\",\"4047\":\"6\",\"4048\":\"\\\"\",\"4049\":\":\",\"4050\":\"\\\"\",\"4051\":\"w\",\"4052\":\"\\\"\",\"4053\":\",\",\"4054\":\"\\\"\",\"4055\":\"3\",\"4056\":\"9\",\"4057\":\"7\",\"4058\":\"\\\"\",\"4059\":\":\",\"4060\":\"\\\"\",\"4061\":\"i\",\"4062\":\"\\\"\",\"4063\":\",\",\"4064\":\"\\\"\",\"4065\":\"3\",\"4066\":\"9\",\"4067\":\"8\",\"4068\":\"\\\"\",\"4069\":\":\",\"4070\":\"\\\"\",\"4071\":\"d\",\"4072\":\"\\\"\",\"4073\":\",\",\"4074\":\"\\\"\",\"4075\":\"3\",\"4076\":\"9\",\"4077\":\"9\",\"4078\":\"\\\"\",\"4079\":\":\",\"4080\":\"\\\"\",\"4081\":\"g\",\"4082\":\"\\\"\",\"4083\":\",\",\"4084\":\"\\\"\",\"4085\":\"4\",\"4086\":\"0\",\"4087\":\"0\",\"4088\":\"\\\"\",\"4089\":\":\",\"4090\":\"\\\"\",\"4091\":\"e\",\"4092\":\"\\\"\",\"4093\":\",\",\"4094\":\"\\\"\",\"4095\":\"4\",\"4096\":\"0\",\"4097\":\"1\",\"4098\":\"\\\"\",\"4099\":\":\",\"4100\":\"\\\"\",\"4101\":\"t\",\"4102\":\"\\\"\",\"4103\":\",\",\"4104\":\"\\\"\",\"4105\":\"4\",\"4106\":\"0\",\"4107\":\"2\",\"4108\":\"\\\"\",\"4109\":\":\",\"4110\":\"\\\"\",\"4111\":\"C\",\"4112\":\"\\\"\",\"4113\":\",\",\"4114\":\"\\\"\",\"4115\":\"4\",\"4116\":\"0\",\"4117\":\"3\",\"4118\":\"\\\"\",\"4119\":\":\",\"4120\":\"\\\"\",\"4121\":\"h\",\"4122\":\"\\\"\",\"4123\":\",\",\"4124\":\"\\\"\",\"4125\":\"4\",\"4126\":\"0\",\"4127\":\"4\",\"4128\":\"\\\"\",\"4129\":\":\",\"4130\":\"\\\"\",\"4131\":\"a\",\"4132\":\"\\\"\",\"4133\":\",\",\"4134\":\"\\\"\",\"4135\":\"4\",\"4136\":\"0\",\"4137\":\"5\",\"4138\":\"\\\"\",\"4139\":\":\",\"4140\":\"\\\"\",\"4141\":\"n\",\"4142\":\"\\\"\",\"4143\":\",\",\"4144\":\"\\\"\",\"4145\":\"4\",\"4146\":\"0\",\"4147\":\"6\",\"4148\":\"\\\"\",\"4149\":\":\",\"4150\":\"\\\"\",\"4151\":\"n\",\"4152\":\"\\\"\",\"4153\":\",\",\"4154\":\"\\\"\",\"4155\":\"4\",\"4156\":\"0\",\"4157\":\"7\",\"4158\":\"\\\"\",\"4159\":\":\",\"4160\":\"\\\"\",\"4161\":\"e\",\"4162\":\"\\\"\",\"4163\":\",\",\"4164\":\"\\\"\",\"4165\":\"4\",\"4166\":\"0\",\"4167\":\"8\",\"4168\":\"\\\"\",\"4169\":\":\",\"4170\":\"\\\"\",\"4171\":\"l\",\"4172\":\"\\\"\",\"4173\":\",\",\"4174\":\"\\\"\",\"4175\":\"4\",\"4176\":\"0\",\"4177\":\"9\",\"4178\":\"\\\"\",\"4179\":\":\",\"4180\":\"\\\"\",\"4181\":\"I\",\"4182\":\"\\\"\",\"4183\":\",\",\"4184\":\"\\\"\",\"4185\":\"4\",\"4186\":\"1\",\"4187\":\"0\",\"4188\":\"\\\"\",\"4189\":\":\",\"4190\":\"\\\"\",\"4191\":\"d\",\"4192\":\"\\\"\",\"4193\":\",\",\"4194\":\"\\\"\",\"4195\":\"4\",\"4196\":\"1\",\"4197\":\"1\",\"4198\":\"\\\"\",\"4199\":\":\",\"4200\":\"\\\"\",\"4201\":\"\\\\\",\"4202\":\"\\\"\",\"4203\":\"\\\"\",\"4204\":\",\",\"4205\":\"\\\"\",\"4206\":\"4\",\"4207\":\"1\",\"4208\":\"2\",\"4209\":\"\\\"\",\"4210\":\":\",\"4211\":\"\\\"\",\"4212\":\":\",\"4213\":\"\\\"\",\"4214\":\",\",\"4215\":\"\\\"\",\"4216\":\"4\",\"4217\":\"1\",\"4218\":\"3\",\"4219\":\"\\\"\",\"4220\":\":\",\"4221\":\"\\\"\",\"4222\":\"\\\\\",\"4223\":\"\\\"\",\"4224\":\"\\\"\",\"4225\":\",\",\"4226\":\"\\\"\",\"4227\":\"4\",\"4228\":\"1\",\"4229\":\"4\",\"4230\":\"\\\"\",\"4231\":\":\",\"4232\":\"\\\"\",\"4233\":\"8\",\"4234\":\"\\\"\",\"4235\":\",\",\"4236\":\"\\\"\",\"4237\":\"4\",\"4238\":\"1\",\"4239\":\"5\",\"4240\":\"\\\"\",\"4241\":\":\",\"4242\":\"\\\"\",\"4243\":\"6\",\"4244\":\"\\\"\",\"4245\":\",\",\"4246\":\"\\\"\",\"4247\":\"4\",\"4248\":\"1\",\"4249\":\"6\",\"4250\":\"\\\"\",\"4251\":\":\",\"4252\":\"\\\"\",\"4253\":\"7\",\"4254\":\"\\\"\",\"4255\":\",\",\"4256\":\"\\\"\",\"4257\":\"4\",\"4258\":\"1\",\"4259\":\"7\",\"4260\":\"\\\"\",\"4261\":\":\",\"4262\":\"\\\"\",\"4263\":\"f\",\"4264\":\"\\\"\",\"4265\":\",\",\"4266\":\"\\\"\",\"4267\":\"4\",\"4268\":\"1\",\"4269\":\"8\",\"4270\":\"\\\"\",\"4271\":\":\",\"4272\":\"\\\"\",\"4273\":\"3\",\"4274\":\"\\\"\",\"4275\":\",\",\"4276\":\"\\\"\",\"4277\":\"4\",\"4278\":\"1\",\"4279\":\"9\",\"4280\":\"\\\"\",\"4281\":\":\",\"4282\":\"\\\"\",\"4283\":\"6\",\"4284\":\"\\\"\",\"4285\":\",\",\"4286\":\"\\\"\",\"4287\":\"4\",\"4288\":\"2\",\"4289\":\"0\",\"4290\":\"\\\"\",\"4291\":\":\",\"4292\":\"\\\"\",\"4293\":\"e\",\"4294\":\"\\\"\",\"4295\":\",\",\"4296\":\"\\\"\",\"4297\":\"4\",\"4298\":\"2\",\"4299\":\"1\",\"4300\":\"\\\"\",\"4301\":\":\",\"4302\":\"\\\"\",\"4303\":\"8\",\"4304\":\"\\\"\",\"4305\":\",\",\"4306\":\"\\\"\",\"4307\":\"4\",\"4308\":\"2\",\"4309\":\"2\",\"4310\":\"\\\"\",\"4311\":\":\",\"4312\":\"\\\"\",\"4313\":\"-\",\"4314\":\"\\\"\",\"4315\":\",\",\"4316\":\"\\\"\",\"4317\":\"4\",\"4318\":\"2\",\"4319\":\"3\",\"4320\":\"\\\"\",\"4321\":\":\",\"4322\":\"\\\"\",\"4323\":\"1\",\"4324\":\"\\\"\",\"4325\":\",\",\"4326\":\"\\\"\",\"4327\":\"4\",\"4328\":\"2\",\"4329\":\"4\",\"4330\":\"\\\"\",\"4331\":\":\",\"4332\":\"\\\"\",\"4333\":\"0\",\"4334\":\"\\\"\",\"4335\":\",\",\"4336\":\"\\\"\",\"4337\":\"4\",\"4338\":\"2\",\"4339\":\"5\",\"4340\":\"\\\"\",\"4341\":\":\",\"4342\":\"\\\"\",\"4343\":\"5\",\"4344\":\"\\\"\",\"4345\":\",\",\"4346\":\"\\\"\",\"4347\":\"4\",\"4348\":\"2\",\"4349\":\"6\",\"4350\":\"\\\"\",\"4351\":\":\",\"4352\":\"\\\"\",\"4353\":\"5\",\"4354\":\"\\\"\",\"4355\":\",\",\"4356\":\"\\\"\",\"4357\":\"4\",\"4358\":\"2\",\"4359\":\"7\",\"4360\":\"\\\"\",\"4361\":\":\",\"4362\":\"\\\"\",\"4363\":\"-\",\"4364\":\"\\\"\",\"4365\":\",\",\"4366\":\"\\\"\",\"4367\":\"4\",\"4368\":\"2\",\"4369\":\"8\",\"4370\":\"\\\"\",\"4371\":\":\",\"4372\":\"\\\"\",\"4373\":\"4\",\"4374\":\"\\\"\",\"4375\":\",\",\"4376\":\"\\\"\",\"4377\":\"4\",\"4378\":\"2\",\"4379\":\"9\",\"4380\":\"\\\"\",\"4381\":\":\",\"4382\":\"\\\"\",\"4383\":\"6\",\"4384\":\"\\\"\",\"4385\":\",\",\"4386\":\"\\\"\",\"4387\":\"4\",\"4388\":\"3\",\"4389\":\"0\",\"4390\":\"\\\"\",\"4391\":\":\",\"4392\":\"\\\"\",\"4393\":\"8\",\"4394\":\"\\\"\",\"4395\":\",\",\"4396\":\"\\\"\",\"4397\":\"4\",\"4398\":\"3\",\"4399\":\"1\",\"4400\":\"\\\"\",\"4401\":\":\",\"4402\":\"\\\"\",\"4403\":\"5\",\"4404\":\"\\\"\",\"4405\":\",\",\"4406\":\"\\\"\",\"4407\":\"4\",\"4408\":\"3\",\"4409\":\"2\",\"4410\":\"\\\"\",\"4411\":\":\",\"4412\":\"\\\"\",\"4413\":\"-\",\"4414\":\"\\\"\",\"4415\":\",\",\"4416\":\"\\\"\",\"4417\":\"4\",\"4418\":\"3\",\"4419\":\"3\",\"4420\":\"\\\"\",\"4421\":\":\",\"4422\":\"\\\"\",\"4423\":\"9\",\"4424\":\"\\\"\",\"4425\":\",\",\"4426\":\"\\\"\",\"4427\":\"4\",\"4428\":\"3\",\"4429\":\"4\",\"4430\":\"\\\"\",\"4431\":\":\",\"4432\":\"\\\"\",\"4433\":\"a\",\"4434\":\"\\\"\",\"4435\":\",\",\"4436\":\"\\\"\",\"4437\":\"4\",\"4438\":\"3\",\"4439\":\"5\",\"4440\":\"\\\"\",\"4441\":\":\",\"4442\":\"\\\"\",\"4443\":\"2\",\"4444\":\"\\\"\",\"4445\":\",\",\"4446\":\"\\\"\",\"4447\":\"4\",\"4448\":\"3\",\"4449\":\"6\",\"4450\":\"\\\"\",\"4451\":\":\",\"4452\":\"\\\"\",\"4453\":\"d\",\"4454\":\"\\\"\",\"4455\":\",\",\"4456\":\"\\\"\",\"4457\":\"4\",\"4458\":\"3\",\"4459\":\"7\",\"4460\":\"\\\"\",\"4461\":\":\",\"4462\":\"\\\"\",\"4463\":\"-\",\"4464\":\"\\\"\",\"4465\":\",\",\"4466\":\"\\\"\",\"4467\":\"4\",\"4468\":\"3\",\"4469\":\"8\",\"4470\":\"\\\"\",\"4471\":\":\",\"4472\":\"\\\"\",\"4473\":\"6\",\"4474\":\"\\\"\",\"4475\":\",\",\"4476\":\"\\\"\",\"4477\":\"4\",\"4478\":\"3\",\"4479\":\"9\",\"4480\":\"\\\"\",\"4481\":\":\",\"4482\":\"\\\"\",\"4483\":\"2\",\"4484\":\"\\\"\",\"4485\":\",\",\"4486\":\"\\\"\",\"4487\":\"4\",\"4488\":\"4\",\"4489\":\"0\",\"4490\":\"\\\"\",\"4491\":\":\",\"4492\":\"\\\"\",\"4493\":\"f\",\"4494\":\"\\\"\",\"4495\":\",\",\"4496\":\"\\\"\",\"4497\":\"4\",\"4498\":\"4\",\"4499\":\"1\",\"4500\":\"\\\"\",\"4501\":\":\",\"4502\":\"\\\"\",\"4503\":\"b\",\"4504\":\"\\\"\",\"4505\":\",\",\"4506\":\"\\\"\",\"4507\":\"4\",\"4508\":\"4\",\"4509\":\"2\",\"4510\":\"\\\"\",\"4511\":\":\",\"4512\":\"\\\"\",\"4513\":\"4\",\"4514\":\"\\\"\",\"4515\":\",\",\"4516\":\"\\\"\",\"4517\":\"4\",\"4518\":\"4\",\"4519\":\"3\",\"4520\":\"\\\"\",\"4521\":\":\",\"4522\":\"\\\"\",\"4523\":\"1\",\"4524\":\"\\\"\",\"4525\":\",\",\"4526\":\"\\\"\",\"4527\":\"4\",\"4528\":\"4\",\"4529\":\"4\",\"4530\":\"\\\"\",\"4531\":\":\",\"4532\":\"\\\"\",\"4533\":\"0\",\"4534\":\"\\\"\",\"4535\":\",\",\"4536\":\"\\\"\",\"4537\":\"4\",\"4538\":\"4\",\"4539\":\"5\",\"4540\":\"\\\"\",\"4541\":\":\",\"4542\":\"\\\"\",\"4543\":\"d\",\"4544\":\"\\\"\",\"4545\":\",\",\"4546\":\"\\\"\",\"4547\":\"4\",\"4548\":\"4\",\"4549\":\"6\",\"4550\":\"\\\"\",\"4551\":\":\",\"4552\":\"\\\"\",\"4553\":\"4\",\"4554\":\"\\\"\",\"4555\":\",\",\"4556\":\"\\\"\",\"4557\":\"4\",\"4558\":\"4\",\"4559\":\"7\",\"4560\":\"\\\"\",\"4561\":\":\",\"4562\":\"\\\"\",\"4563\":\"b\",\"4564\":\"\\\"\",\"4565\":\",\",\"4566\":\"\\\"\",\"4567\":\"4\",\"4568\":\"4\",\"4569\":\"8\",\"4570\":\"\\\"\",\"4571\":\":\",\"4572\":\"\\\"\",\"4573\":\"0\",\"4574\":\"\\\"\",\"4575\":\",\",\"4576\":\"\\\"\",\"4577\":\"4\",\"4578\":\"4\",\"4579\":\"9\",\"4580\":\"\\\"\",\"4581\":\":\",\"4582\":\"\\\"\",\"4583\":\"5\",\"4584\":\"\\\"\",\"4585\":\",\",\"4586\":\"\\\"\",\"4587\":\"4\",\"4588\":\"5\",\"4589\":\"0\",\"4590\":\"\\\"\",\"4591\":\":\",\"4592\":\"\\\"\",\"4593\":\"\\\\\",\"4594\":\"\\\"\",\"4595\":\"\\\"\",\"4596\":\",\",\"4597\":\"\\\"\",\"4598\":\"4\",\"4599\":\"5\",\"4600\":\"1\",\"4601\":\"\\\"\",\"4602\":\":\",\"4603\":\"\\\"\",\"4604\":\"}\",\"4605\":\"\\\"\",\"4606\":\",\",\"4607\":\"\\\"\",\"4608\":\"w\",\"4609\":\"i\",\"4610\":\"d\",\"4611\":\"g\",\"4612\":\"e\",\"4613\":\"t\",\"4614\":\"C\",\"4615\":\"h\",\"4616\":\"a\",\"4617\":\"n\",\"4618\":\"n\",\"4619\":\"e\",\"4620\":\"l\",\"4621\":\"I\",\"4622\":\"d\",\"4623\":\"\\\"\",\"4624\":\":\",\"4625\":\"\\\"\",\"4626\":\"8\",\"4627\":\"6\",\"4628\":\"7\",\"4629\":\"f\",\"4630\":\"3\",\"4631\":\"6\",\"4632\":\"e\",\"4633\":\"8\",\"4634\":\"-\",\"4635\":\"1\",\"4636\":\"0\",\"4637\":\"5\",\"4638\":\"5\",\"4639\":\"-\",\"4640\":\"4\",\"4641\":\"6\",\"4642\":\"8\",\"4643\":\"5\",\"4644\":\"-\",\"4645\":\"9\",\"4646\":\"a\",\"4647\":\"2\",\"4648\":\"d\",\"4649\":\"-\",\"4650\":\"6\",\"4651\":\"2\",\"4652\":\"f\",\"4653\":\"b\",\"4654\":\"4\",\"4655\":\"1\",\"4656\":\"0\",\"4657\":\"d\",\"4658\":\"4\",\"4659\":\"b\",\"4660\":\"0\",\"4661\":\"5\",\"4662\":\"\\\"\",\"4663\":\"}\",\"widgetChannelId\":\"867f36e8-1055-4685-9a2d-62fb410d4b05\"}}', '2026-10-22 09:08:18.423');
INSERT INTO `audit_events` (`id`, `workspace_id`, `actor_user_id`, `actor_type`, `action`, `resource_type`, `resource_id`, `outcome`, `ip`, `user_agent`, `metadata`, `created_at`) VALUES
('57262f8d-3fd4-4ada-a1c2-ad581689527c', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.send', 'campaign', '0e94f491-bbf8-47be-995a-fa76dfaa7a33', 'success', '::ffff:127.0.0.1', NULL, '{\"scheduled\":false,\"runAt\":null}', '2026-10-24 15:13:49.131'),
('59430a3d-654b-4d00-8d6d-c19de3e3760b', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.publish', 'agent', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'success', '::ffff:127.0.0.1', NULL, '{\"version\":1}', '2026-10-24 15:00:47.518'),
('595063ea-928f-4873-9e72-17d0badff84f', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'knowledge.source_reindex', 'knowledge_source', 'source-1', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-30 14:09:28.783'),
('596afb35-5eb8-47fc-9011-db8a4e439337', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.delete', 'campaign', 'b8db83db-f793-46b8-84f7-cac890467a37', 'success', '::1', NULL, '{\"name\":\"Smoke test\",\"status\":\"completed\"}', '2026-10-24 15:03:14.698'),
('59daf4a8-28f6-4087-a456-2e8b68d523a6', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.delete', 'campaign', '770b4dcb-53d2-486a-be11-94836fb4a78c', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"Template test\",\"status\":\"draft\"}', '2026-10-24 15:18:58.616'),
('5b0d9906-6bd8-444f-b313-bf70fab464af', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::ffff:127.0.0.1', 'node', '{}', '2026-10-24 15:22:26.996'),
('5d13484d-2436-41e3-986e-6adde48deb29', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.send', 'campaign', '13e39da4-595c-482f-926c-304f034f0771', 'success', '::ffff:127.0.0.1', NULL, '{\"scheduled\":false,\"runAt\":null}', '2026-10-24 15:13:49.192'),
('5ee65e9d-39c4-4493-8d57-6f391c01e5b0', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.create', 'channel', '7fa12482-de20-49e1-ad6b-742e7f58623a', 'success', '::ffff:127.0.0.1', NULL, '{\"type\":\"website\",\"name\":\"wwww\"}', '2026-10-24 15:49:49.743'),
('5f00e192-ccdc-41d1-a1af-c873ff961ca2', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-31 16:39:24.783'),
('6055b124-2950-4053-b579-584528cd457c', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'campaigns.send', 'campaign', 'a960368e-d6f1-485f-b4d6-52a8f8082840', 'success', '::ffff:127.0.0.1', NULL, '{\"scheduled\":false,\"runAt\":null}', '2026-10-30 11:55:49.790'),
('60c13302-c7a1-44f1-aad9-4eddbf988011', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::ffff:127.0.0.1', 'node', '{}', '2026-10-24 15:22:35.727'),
('619140bb-c16d-42bc-a351-eefa4a5dbfa1', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.recipients.add', 'campaign', '4e0f088a-2775-4339-80fb-cc7c4f049529', 'success', '::1', NULL, '{\"added\":1,\"suppressed\":0}', '2026-10-24 14:55:56.666'),
('63f7f951-c82b-40d9-978e-ecc624645c2d', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'flows.update', 'flow', '863c7b68-700e-4430-8de0-7919e82d40b0', 'success', '::ffff:127.0.0.1', NULL, '{\"fields\":[\"definition\"]}', '2026-10-20 10:13:20.562'),
('64abc7f2-a0e0-4812-9f1a-eb315dd5579d', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.delete', 'campaign', '3a045816-a2c7-4098-a710-1024e12bfbd6', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"Proxy test\",\"status\":\"draft\"}', '2026-10-24 15:18:58.676'),
('6864be44-060a-48e6-ae76-9984cf38e3bb', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'flows.publish', 'flow', 'flow-2', 'success', '::ffff:127.0.0.1', NULL, '{\"version\":1}', '2026-10-30 14:22:19.534'),
('6bc2b85b-1633-4262-92bb-27424a3f98b8', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::ffff:127.0.0.1', 'node', '{}', '2026-10-27 10:38:39.995'),
('6c64f362-fe2f-4b70-b109-4f525e4d0649', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'flows.update', 'flow', '6e84e2c2-dcc5-44b4-b613-6fedef216458', 'success', '::ffff:127.0.0.1', NULL, '{\"fields\":[\"triggerType\"]}', '2026-10-20 11:33:11.827'),
('6cb09f9a-f945-4cfd-b912-a247b1a5a312', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'auth.login', 'user', '59627376-d414-4b33-a8c5-756cf5d231a1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '{}', '2026-10-20 16:22:05.825'),
('719da809-8eb1-41f4-bd88-fbe3b8f2ddf9', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'auth.login', 'user', '59627376-d414-4b33-a8c5-756cf5d231a1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '{}', '2026-10-30 11:20:10.534'),
('71eb9a0f-ab4a-4643-bea5-89ffba524e18', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.create', 'channel', '640e8857-0c3f-4aab-9c29-8e2639936cce', 'success', '::ffff:127.0.0.1', NULL, '{\"type\":\"openwa\",\"name\":\"testChat\"}', '2026-10-22 09:02:35.460'),
('720a8852-9c5e-4dfa-a594-5bafc87b17d6', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::ffff:127.0.0.1', 'node', '{}', '2026-10-24 15:13:49.064'),
('730ee1b0-6d9d-4442-a9db-77783d2bb0fa', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.update', 'channel', 'afaa0c17-bfed-4ff3-a03a-823638a84319', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-24 15:01:17.271'),
('734e15b5-74f9-406e-894f-98f1ca12fe93', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::ffff:127.0.0.1', 'node', '{}', '2026-10-24 15:17:35.698'),
('74e31f91-5958-4966-8c61-c02adf6f39f5', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.create', 'campaign', '1cada601-5845-4665-817f-4f54af2d6a66', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"Schedule test\",\"channelType\":\"whatsapp\",\"audienceMode\":\"all\",\"matched\":2,\"deliverable\":1,\"suppressed\":1}', '2026-10-24 15:18:58.212'),
('755a14ce-895d-4732-a6b7-0deda2fc084c', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.create', 'campaign', '79a798b2-9629-4b78-b500-55f871688992', 'success', '::1', NULL, '{\"name\":\"E2E final\",\"channelType\":\"whatsapp\",\"audienceMode\":\"manual\",\"matched\":2,\"deliverable\":2,\"suppressed\":0}', '2026-10-24 15:06:33.615'),
('75794b27-f0e3-4e29-b34e-343f195f2305', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'auth.login', 'user', '59627376-d414-4b33-a8c5-756cf5d231a1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '{}', '2026-10-22 08:54:10.867'),
('765b75c5-22db-496a-8c72-6145702e9054', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'agents.tools_update', 'agent', '67dfa8ec-4786-4dba-8554-307742710dcb', 'success', '::ffff:127.0.0.1', NULL, '{\"count\":2}', '2026-10-20 10:18:28.913'),
('76f59854-9be7-4e67-959d-ea93405b1830', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.recipients.add', 'campaign', 'eea185ab-60f9-4421-9269-04a2dfcb05b0', 'success', '::1', NULL, '{\"added\":3,\"suppressed\":1}', '2026-10-24 14:55:32.352'),
('771141a6-7cdc-4066-b261-6747103899a9', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'channels.credentials_update', 'channel', 'dae48be3-ac91-48a1-b4e6-7323e66afefe', 'success', '::ffff:127.0.0.1', NULL, '{\"fields\":[\"baseUrl\",\"apiKey\"]}', '2026-10-22 06:00:40.583'),
('78f38456-0076-4d02-8afa-a7b7e0042fd9', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'auth.login', 'user', '59627376-d414-4b33-a8c5-756cf5d231a1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '{}', '2026-10-27 10:41:41.282'),
('79f8157a-8094-448d-bc69-bf1515be2be0', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-22 10:41:28.337'),
('7a4f704a-222e-43c8-8bd3-8824c4b0a7cf', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.playground', 'agent', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'success', '::ffff:127.0.0.1', NULL, '{\"escalated\":false,\"iterations\":1}', '2026-10-29 12:10:13.777'),
('7c320093-e835-46c8-be20-bdb30aa995fc', NULL, '78f88de2-49db-4994-9db3-4e190abefe46', 'user', 'auth.register', 'user', '78f88de2-49db-4994-9db3-4e190abefe46', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '{\"workspaceId\":\"951f0dbc-1a1f-44ed-aa74-e828ee8d6953\"}', '2026-10-22 08:52:46.156'),
('7eb85a83-649e-49c6-a159-05bb09ba6b2d', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'channels.update', 'channel', '048c105a-3177-4c66-b5ef-32fe95eba2f9', 'success', '::1', NULL, '{}', '2026-10-31 16:44:07.647'),
('812c1ba3-3f6f-4f5c-aa36-ad670b462a33', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.create', 'channel', 'afaa0c17-bfed-4ff3-a03a-823638a84319', 'success', '::ffff:127.0.0.1', NULL, '{\"type\":\"website\",\"name\":\"Whatuptes\"}', '2026-10-24 14:58:52.169'),
('8295c272-2e7b-4d45-970b-c5bca800304b', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'flows.update', 'flow', 'flow-2', 'success', '::ffff:127.0.0.1', NULL, '{\"fields\":[\"definition\"]}', '2026-10-30 14:24:26.018'),
('851d1350-1655-44c2-a4ae-798469dd30cf', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.update', 'agent', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-29 12:13:06.913'),
('85980ffc-6fe5-40e2-b0d8-b6b26fc7d262', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-24 15:06:33.475'),
('8686dc8a-7edb-494a-a0ee-e14ebb56d235', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.delete', 'campaign', '13e39da4-595c-482f-926c-304f034f0771', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"Test campaign\",\"status\":\"cancelled\"}', '2026-10-24 15:13:49.213'),
('8770c8e2-fa82-4659-87b3-2e0a3781948a', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.cancel', 'campaign', '0e94f491-bbf8-47be-995a-fa76dfaa7a33', 'success', '::ffff:127.0.0.1', NULL, '{\"from\":\"running\",\"to\":\"cancelled\"}', '2026-10-24 15:13:49.151'),
('897333aa-8d9c-4eee-b2b6-fe9fb8350fde', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'templates.create', 'template', '43cc52d1-f986-40cc-8539-233a46cb010b', 'success', '::1', NULL, '{\"name\":\"Greeting2\",\"channelType\":\"whatsapp\",\"language\":\"en\"}', '2026-10-24 14:42:58.433'),
('8ac7cd19-3a11-4138-b888-34ff0ff0b5ad', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-22 08:22:05.344'),
('8b74681b-df52-4f64-ba10-cfecfc684a44', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'templates.create', 'template', 'ed993aa9-d368-4228-a234-95315fa0c522', 'success', '::1', NULL, '{\"name\":\"Greeting\",\"channelType\":\"whatsapp\",\"language\":\"en\"}', '2026-10-24 14:42:19.865'),
('8c3f92b9-9e23-443a-b875-d706efdb0669', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'knowledge.source_reindex', 'knowledge_source', 'source-1', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-30 14:09:30.684'),
('8d157584-2202-4148-b51b-a67edc439055', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.update', 'channel', '867f36e8-1055-4685-9a2d-62fb410d4b05', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-22 06:17:33.467'),
('8d363a9e-e0e4-4d54-9e42-d49dbb97b592', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'channels.create', 'channel', 'dae48be3-ac91-48a1-b4e6-7323e66afefe', 'success', '::ffff:127.0.0.1', NULL, '{\"type\":\"openwa\",\"name\":\"WhatsApp (open-wa)\"}', '2026-10-22 06:00:12.272'),
('8e730a62-07af-4ad3-86d7-6cbd9648d95a', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.update', 'channel', '867f36e8-1055-4685-9a2d-62fb410d4b05', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-22 08:21:15.540'),
('8e8965ef-6a94-45eb-9968-23c353e1964f', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-22 11:15:20.515'),
('919dc37e-f2ce-4a05-9eb8-5d01c6218f10', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'campaigns.create', 'campaign', 'a960368e-d6f1-485f-b4d6-52a8f8082840', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"op\",\"channelType\":\"whatsapp\",\"audienceMode\":\"manual\",\"matched\":1,\"deliverable\":1,\"suppressed\":0}', '2026-10-24 16:00:49.558'),
('91eee5eb-98fa-4807-8d24-9950b7e13702', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.create', 'campaign', '1fdf2b89-96fc-4165-b4b9-92b86cdb2512', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"CSV\",\"channelType\":\"whatsapp\",\"audienceMode\":\"manual\",\"matched\":1,\"deliverable\":1,\"suppressed\":0}', '2026-10-24 15:18:58.137'),
('955df19c-9487-4cae-a5a0-2347ebbefefa', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-22 11:39:43.380'),
('978ba812-e0c9-4fae-bbfb-21b90f55e210', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.create', 'campaign', 'b8db83db-f793-46b8-84f7-cac890467a37', 'success', '::1', NULL, '{\"name\":\"Smoke test\",\"channelType\":\"whatsapp\",\"audienceMode\":\"manual\",\"matched\":2,\"deliverable\":2,\"suppressed\":0}', '2026-10-24 15:03:06.594'),
('9a7299e1-a43f-49ca-8342-16935b4d927f', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.create', 'campaign', '3a045816-a2c7-4098-a710-1024e12bfbd6', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"Proxy test\",\"channelType\":\"whatsapp\",\"audienceMode\":\"all\",\"matched\":2,\"deliverable\":1,\"suppressed\":1}', '2026-10-24 15:17:35.800'),
('9a949fa1-7e55-41a6-8c76-29aed731cd4d', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-31 16:41:44.019'),
('9e4eb293-9276-4c52-9d71-79fa3a2b4aca', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'templates.update', 'template', '06920ea3-68a6-4168-ac82-4eabe50b32eb', 'success', '::1', NULL, '{\"fields\":[\"body\"]}', '2026-10-24 14:42:19.697'),
('a124d5bc-4d07-401d-8a05-cab029e27507', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.create', 'campaign', '13e39da4-595c-482f-926c-304f034f0771', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"Test campaign\",\"channelType\":\"whatsapp\",\"audienceMode\":\"manual\",\"matched\":1,\"deliverable\":1,\"suppressed\":0}', '2026-10-24 15:13:49.180'),
('a1a1d2e4-a261-482a-be0a-112b5cfb7f4a', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'agents.archive', 'agent', '67dfa8ec-4786-4dba-8554-307742710dcb', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-20 10:18:29.075'),
('a24d8d33-d465-4f7a-8c09-78054f606bf3', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.update', 'agent', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-27 10:44:19.125'),
('a4541e33-c02f-49b6-a350-6d0b18357293', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.create', 'channel', '28ba790c-b54a-483b-861c-aaa0dc4e24ae', 'success', '::ffff:127.0.0.1', NULL, '{\"type\":\"whatsapp\",\"name\":\"whtsup\"}', '2026-10-20 10:05:09.277'),
('a6b450d1-485e-4730-897d-b95618575b47', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.create', 'channel', '32288852-fbae-4fc0-ba4e-c4a92d12e2b2', 'success', '::ffff:127.0.0.1', NULL, '{\"type\":\"whatsapp\",\"name\":\"test\"}', '2026-10-22 16:52:49.720'),
('a816c99f-763f-4ec2-8e13-d20c19af06ca', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-22 10:41:52.324'),
('ac539dd6-d64b-455d-984d-fb8c1e374575', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.credentials_update', 'channel', '048c105a-3177-4c66-b5ef-32fe95eba2f9', 'success', '::ffff:127.0.0.1', NULL, '{\"fields\":[\"botToken\"]}', '2026-10-31 16:43:40.729'),
('ad9fe40d-3ac9-4bf7-808e-aefea54e99c3', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'workspace.plan_change', 'workspace', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'success', '::ffff:127.0.0.1', NULL, '{\"plan\":\"enterprise\"}', '2026-10-24 16:10:58.473'),
('ae-1', 'ws-1', 'user-1', 'user', 'login', 'user', 'user-1', 'success', '127.0.0.1', 'Test Agent', '{\"login_method\": \"password\"}', '2026-10-29 14:33:00.315'),
('ae-2', 'ws-1', 'user-2', 'user', 'login', 'user', 'user-2', 'success', '127.0.0.1', 'Test Agent', '{\"login_method\": \"password\"}', '2026-10-29 14:33:00.315'),
('b0136b6c-d9fd-427b-9423-86e787b81887', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.update', 'channel', '640e8857-0c3f-4aab-9c29-8e2639936cce', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-22 09:28:14.931'),
('b11c732f-ba0f-4a68-90e6-ebdf01fe8416', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'auth.login', 'user', '59627376-d414-4b33-a8c5-756cf5d231a1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '{}', '2026-10-29 11:03:26.715'),
('b686cfa0-e175-4d07-8c6a-e0835b243464', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'channels.credentials_update', 'channel', '048c105a-3177-4c66-b5ef-32fe95eba2f9', 'success', '::1', NULL, '{\"fields\":[\"botToken\"]}', '2026-10-31 16:46:05.580'),
('ba390b0e-4b4d-4bc7-90a0-834e577e4799', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-22 05:58:54.349'),
('bb2fa09a-cbb4-4594-9644-faaeca268588', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-20 10:13:20.455'),
('bb9d5cdf-38cf-4442-a990-4ac3ceb5ad40', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-31 16:42:34.944'),
('bfe7e978-9fc7-4c64-a4b1-cfca5d1fa508', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'workspace.plan_change', 'workspace', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'success', '::ffff:127.0.0.1', NULL, '{\"plan\":\"starter\"}', '2026-10-24 16:10:49.007'),
('c38bc10c-9eef-4e2a-b567-0acc0e8e69a4', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.create', 'channel', '0a6204d7-6747-45fb-8c83-28a9c3c9f43c', 'success', '::ffff:127.0.0.1', NULL, '{\"type\":\"website\",\"name\":\"eee\"}', '2026-10-20 10:49:50.883'),
('c40f78a6-d06e-4656-831d-b14602a50e30', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-20 10:12:57.138'),
('c633e0e0-5812-4ccc-ba2f-145fdd849605', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-20 10:13:07.110'),
('c810cf05-4334-43bd-9bb5-fb3700387dfb', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-24 15:03:30.958'),
('c86917d1-bbf1-4047-8a3a-edf3653b6cfe', NULL, '567797f6-c8d3-4ea0-b53a-19838a82f44a', 'user', 'auth.login', 'user', '567797f6-c8d3-4ea0-b53a-19838a82f44a', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '{}', '2026-10-20 12:02:51.996'),
('c8917c4f-6169-485c-b910-aa7cdf21397d', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.delete', 'campaign', '4980cd90-21aa-48e1-89e0-301797004901', 'success', '::1', NULL, '{\"name\":\"Inspect test\",\"status\":\"draft\"}', '2026-10-24 15:03:31.110'),
('c94f262a-c949-4e27-8649-b50a52736434', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.update', 'channel', '867f36e8-1055-4685-9a2d-62fb410d4b05', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-24 14:57:46.813'),
('ca44b5fa-ccf7-4347-8a99-25bb45fbafd2', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'channels.update', 'channel', 'dae48be3-ac91-48a1-b4e6-7323e66afefe', 'success', '::1', NULL, '{}', '2026-10-22 11:15:06.018'),
('caffeafb-1aa6-4353-b661-b7405e39c1a0', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'auth.login', 'user', '59627376-d414-4b33-a8c5-756cf5d231a1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '{}', '2026-10-24 14:33:54.286'),
('cc159b0a-65e1-41b8-a5c9-53c18405335b', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'agents.version_save', 'agent', '67dfa8ec-4786-4dba-8554-307742710dcb', 'success', '::ffff:127.0.0.1', NULL, '{\"version\":1}', '2026-10-20 10:18:28.885'),
('cfd950ab-6849-4f0c-89e1-1bd4daac0a12', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.playground', 'agent', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'success', '::ffff:127.0.0.1', NULL, '{\"escalated\":false,\"iterations\":1}', '2026-10-20 11:31:50.352'),
('d42ee8ba-f88d-4dac-9eee-73d5146d166c', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.send', 'campaign', 'b8db83db-f793-46b8-84f7-cac890467a37', 'success', '::1', NULL, '{\"scheduled\":false,\"runAt\":null}', '2026-10-24 15:03:06.652'),
('d45e4b54-dba9-4d35-beab-fb16c15741ef', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-31 16:45:36.172'),
('d543edb7-4515-4940-9325-7bc6037ad8f8', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-24 15:03:06.268'),
('d6ea5b6d-61ed-46cb-82c7-7a7818f7a66b', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.delete', 'campaign', 'eea185ab-60f9-4421-9269-04a2dfcb05b0', 'success', '::1', NULL, '{\"name\":\"Test broadcast\"}', '2026-10-24 14:55:56.697'),
('d8673b89-652e-4c96-8561-9c0b4c1a6db1', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'auth.login', 'user', '59627376-d414-4b33-a8c5-756cf5d231a1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '{}', '2026-10-20 09:40:18.823'),
('daa2a255-cfb8-4144-b6dc-66c589b3284e', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.send', 'campaign', 'eea185ab-60f9-4421-9269-04a2dfcb05b0', 'success', '::1', NULL, '{}', '2026-10-24 14:55:32.400'),
('daf4e7e4-e156-4fe7-8fcd-fa6d2d0b0097', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::ffff:127.0.0.1', 'node', '{}', '2026-10-27 10:34:35.928'),
('dd28f322-1c34-4beb-bfc1-50a68bbcd79f', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'auth.login', 'user', '59627376-d414-4b33-a8c5-756cf5d231a1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '{}', '2026-10-20 09:00:46.062'),
('dd324491-1623-4bc2-8a84-0b02fc910d73', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-22 11:22:39.780'),
('dd673468-40a2-485b-a1a4-30f50e7e11b5', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.playground', 'agent', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'success', '::ffff:127.0.0.1', NULL, '{\"escalated\":false,\"iterations\":1}', '2026-10-20 11:54:30.684'),
('dd92b9cc-e2b5-4271-a23b-4e31cd79122d', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.delete', 'campaign', '1fdf2b89-96fc-4165-b4b9-92b86cdb2512', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"CSV\",\"status\":\"draft\"}', '2026-10-24 15:22:35.772'),
('e0c3a80d-20a4-47fe-b6ea-f74f2d1ef095', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'auth.login', 'user', '59627376-d414-4b33-a8c5-756cf5d231a1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '{}', '2026-10-20 10:18:59.605'),
('e1e20629-8165-43c0-9fd5-aaca9e267144', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.update', 'channel', '867f36e8-1055-4685-9a2d-62fb410d4b05', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-22 09:08:18.329'),
('e2d851a1-b5d3-406d-8c7d-6da2f43b44c4', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-31 16:44:07.551'),
('e4352c3c-c6b1-4edb-91ac-d134a13791c8', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.send', 'campaign', '1cada601-5845-4665-817f-4f54af2d6a66', 'success', '::ffff:127.0.0.1', NULL, '{\"scheduled\":true,\"runAt\":\"2026-10-24T16:18:58.236Z\"}', '2026-10-24 15:18:58.273'),
('e80b90c3-3561-4212-ae40-a2b4625d840f', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.playground', 'agent', 'f803b4a0-5da6-4912-ba1d-4a8fb2af9638', 'success', '::ffff:127.0.0.1', NULL, '{\"escalated\":false,\"iterations\":1}', '2026-10-29 14:03:03.077'),
('e88d7d4c-1182-4f6e-a302-65b62123a408', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.delete', 'campaign', '4e0f088a-2775-4339-80fb-cc7c4f049529', 'success', '::1', NULL, '{\"name\":\"Dedup test\"}', '2026-10-24 14:55:56.690'),
('e8f35686-6ae5-4939-9b92-438baa066edf', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'flows.create', 'flow', '6e84e2c2-dcc5-44b4-b613-6fedef216458', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"abc\",\"triggerType\":\"conversation.created\"}', '2026-10-20 10:48:27.563'),
('eaef05dd-0347-4bb0-965a-2f7e406806a3', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'auth.login', 'user', '59627376-d414-4b33-a8c5-756cf5d231a1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '{}', '2026-10-27 10:30:04.633'),
('edd94f10-0b1d-47ed-a74d-1f8fba3ed0c4', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.version_save', 'agent', 'f803b4a0-5da6-4912-ba1d-4a8fb2af9638', 'success', '::ffff:127.0.0.1', NULL, '{\"version\":2}', '2026-10-30 11:22:04.388'),
('eddb7748-62a3-4c73-8586-93a8faff62b6', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.create', 'campaign', '770b4dcb-53d2-486a-be11-94836fb4a78c', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"Template test\",\"channelType\":\"whatsapp\",\"audienceMode\":\"all\",\"matched\":2,\"deliverable\":1,\"suppressed\":1}', '2026-10-24 15:18:58.586'),
('f12717ed-7c71-49f6-aac1-766c98a0680a', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-22 10:41:06.899'),
('f136f9be-d327-4288-afee-f9a0f607559e', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-24 14:55:56.598'),
('f3e340cb-08f7-4195-8884-bc95e0bf9cf6', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.delete', 'campaign', '1cada601-5845-4665-817f-4f54af2d6a66', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"Schedule test\",\"status\":\"cancelled\"}', '2026-10-24 15:18:58.417'),
('f4947da6-b9b3-4970-8a0e-affb5fefa4fa', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.update', 'channel', 'a974ac21-61f4-476f-83c7-3bb797bfe758', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-29 14:40:09.200'),
('f53d0580-7560-4185-a39d-ae9ac6993d43', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-31 16:43:06.210'),
('f5802748-0dff-4d55-b4d0-1ed67589655b', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-22 05:59:22.116'),
('f9251695-70e6-44a8-93a1-96f81967c5e4', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'templates.delete', 'template', '43cc52d1-f986-40cc-8539-233a46cb010b', 'success', '::1', NULL, '{\"name\":\"Greeting2\"}', '2026-10-24 14:42:58.587'),
('f92eb66e-30cd-41aa-aa0a-411f5374b221', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'agents.create', 'agent', '67dfa8ec-4786-4dba-8554-307742710dcb', 'success', '::ffff:127.0.0.1', NULL, '{\"name\":\"CRUD smoke agent\",\"type\":\"support\"}', '2026-10-20 10:18:28.846'),
('fae0e72b-961e-4c0c-8a23-e02d852e4032', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'campaigns.delete', 'campaign', '79a798b2-9629-4b78-b500-55f871688992', 'success', '::1', NULL, '{\"name\":\"E2E final\",\"status\":\"completed\"}', '2026-10-24 15:06:41.729'),
('fb1a25c8-9036-4ca0-99c8-87f61a903264', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'flows.update', 'flow', 'flow-2', 'success', '::ffff:127.0.0.1', NULL, '{\"fields\":[\"triggerType\"]}', '2026-10-30 14:24:37.593'),
('fb9b6a12-3010-468f-a860-45b93771b002', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.playground', 'agent', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'success', '::ffff:127.0.0.1', NULL, '{\"escalated\":false,\"iterations\":1}', '2026-10-20 11:55:04.324'),
('fce79541-50dc-4493-95b0-908c6238bfbc', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'auth.login', 'user', '59627376-d414-4b33-a8c5-756cf5d231a1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '{}', '2026-10-20 09:58:00.713'),
('fd1567cc-9179-4397-9b25-7e03ee7d910a', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'user', 'auth.login', 'user', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'success', '::ffff:127.0.0.1', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '{}', '2026-10-20 10:18:28.667'),
('feceac33-5715-4320-9283-be9415ce23af', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'channels.update', 'channel', '048c105a-3177-4c66-b5ef-32fe95eba2f9', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-31 16:42:38.029'),
('fee15747-b450-4be5-b4bc-ea69630e4789', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'user', 'agents.update', 'agent', 'f803b4a0-5da6-4912-ba1d-4a8fb2af9638', 'success', '::ffff:127.0.0.1', NULL, '{}', '2026-10-29 14:02:45.102');

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `service_id` varchar(36) NOT NULL,
  `slot_id` varchar(36) NOT NULL,
  `contact_id` varchar(36) DEFAULT NULL,
  `conversation_id` varchar(36) DEFAULT NULL,
  `customer_name` varchar(255) NOT NULL,
  `customer_phone` varchar(64) DEFAULT NULL,
  `customer_email` varchar(255) DEFAULT NULL,
  `start_at` datetime(3) NOT NULL,
  `end_at` datetime(3) NOT NULL,
  `timezone` varchar(64) NOT NULL DEFAULT 'UTC',
  `status` enum('pending','confirmed','cancelled','completed','no_show') NOT NULL DEFAULT 'pending',
  `notes` text DEFAULT NULL,
  `cancel_reason` varchar(255) DEFAULT NULL,
  `external_id` varchar(191) DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `booking_services`
--

CREATE TABLE `booking_services` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `duration_minutes` int(11) NOT NULL DEFAULT 30,
  `capacity` int(11) NOT NULL DEFAULT 1,
  `buffer_minutes` int(11) NOT NULL DEFAULT 0,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `timezone` varchar(64) NOT NULL DEFAULT 'UTC',
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `booking_slots`
--

CREATE TABLE `booking_slots` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `service_id` varchar(36) NOT NULL,
  `start_at` datetime(3) NOT NULL,
  `end_at` datetime(3) NOT NULL,
  `capacity` int(11) NOT NULL DEFAULT 1,
  `booked` int(11) NOT NULL DEFAULT 0,
  `status` enum('open','closed','full') NOT NULL DEFAULT 'open',
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `campaigns`
--

CREATE TABLE `campaigns` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `name` varchar(191) NOT NULL,
  `channel_type` enum('whatsapp','telegram','email','website') NOT NULL,
  `template_id` varchar(36) DEFAULT NULL,
  `audience` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`audience`)),
  `message_body` text DEFAULT NULL,
  `status` enum('draft','scheduled','running','paused','completed','failed','cancelled') NOT NULL DEFAULT 'draft',
  `scheduled_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) DEFAULT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `confirmed_at` datetime(3) DEFAULT NULL,
  `recipient_count` int(11) NOT NULL DEFAULT 0,
  `sent_count` int(11) NOT NULL DEFAULT 0,
  `failed_count` int(11) NOT NULL DEFAULT 0,
  `suppressed_count` int(11) NOT NULL DEFAULT 0,
  `created_by` varchar(36) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `campaigns`
--

INSERT INTO `campaigns` (`id`, `workspace_id`, `name`, `channel_type`, `template_id`, `audience`, `message_body`, `status`, `scheduled_at`, `started_at`, `finished_at`, `confirmed_at`, `recipient_count`, `sent_count`, `failed_count`, `suppressed_count`, `created_by`, `created_at`, `updated_at`) VALUES
('a960368e-d6f1-485f-b4d6-52a8f8082840', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'op', 'whatsapp', NULL, '{\"mode\":\"manual\",\"contacts\":[{\"phone\":\"hhhhh\"}]}', 'HI {{name }} this promo avaialabe on 20th oct', 'completed', NULL, '2026-10-30 11:55:49.785', '2026-10-30 11:55:50.157', '2026-10-30 11:55:49.785', 1, 0, 1, 0, '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-24 16:00:49.526', '2026-10-30 11:55:50.157');

-- --------------------------------------------------------

--
-- Table structure for table `campaign_recipients`
--

CREATE TABLE `campaign_recipients` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `campaign_id` varchar(36) NOT NULL,
  `contact_id` varchar(36) DEFAULT NULL,
  `phone` varchar(64) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `personalization` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`personalization`)),
  `status` enum('pending','suppressed','sending','sent','failed','delivered','read') NOT NULL DEFAULT 'pending',
  `suppress_reason` varchar(191) DEFAULT NULL,
  `attempts` int(11) NOT NULL DEFAULT 0,
  `sent_at` datetime(3) DEFAULT NULL,
  `last_error` text DEFAULT NULL,
  `provider_message_id` varchar(191) DEFAULT NULL,
  `idempotency_key` varchar(191) NOT NULL,
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3),
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `campaign_recipients`
--

INSERT INTO `campaign_recipients` (`id`, `workspace_id`, `campaign_id`, `contact_id`, `phone`, `email`, `name`, `personalization`, `status`, `suppress_reason`, `attempts`, `sent_at`, `last_error`, `provider_message_id`, `idempotency_key`, `updated_at`, `created_at`) VALUES
('8f9e43e5-69d8-41c8-84a6-384fd784472a', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'a960368e-d6f1-485f-b4d6-52a8f8082840', NULL, 'hhhhh', NULL, NULL, NULL, 'failed', NULL, 1, NULL, 'No connected whatsapp channel in this workspace', NULL, 'a960368e-d6f1-485f-b4d6-52a8f8082840:hhhhh', '2026-10-30 11:55:49.903', '2026-10-24 16:00:49.550');

-- --------------------------------------------------------

--
-- Table structure for table `channels`
--

CREATE TABLE `channels` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `type` enum('website','whatsapp','telegram','discord','slack','email','indiamart','tradeindia','webhook','openwa') NOT NULL,
  `name` varchar(191) NOT NULL,
  `status` enum('disconnected','pending','connected','error') NOT NULL DEFAULT 'disconnected',
  `agent_id` varchar(36) DEFAULT NULL,
  `automation_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`config`)),
  `last_sync_at` datetime(3) DEFAULT NULL,
  `last_error` text DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `channels`
--

INSERT INTO `channels` (`id`, `workspace_id`, `type`, `name`, `status`, `agent_id`, `automation_enabled`, `config`, `last_sync_at`, `last_error`, `created_by`, `created_at`, `updated_at`) VALUES
('048c105a-3177-4c66-b5ef-32fe95eba2f9', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'telegram', 'Telegram - avpsofttechbot', 'connected', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, '{\"pollOffset\":164872745}', '2026-10-31 16:49:43.648', NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', '2026-10-31 16:41:44.331', '2026-10-31 16:49:43.648'),
('0a6204d7-6747-45fb-8c83-28a9c3c9f43c', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'website', 'eee', 'connected', NULL, 1, '{}', NULL, NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-20 10:49:50.877', '2026-10-20 10:49:50.877'),
('28ba790c-b54a-483b-861c-aaa0dc4e24ae', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'whatsapp', 'whtsup', 'pending', NULL, 1, '{}', NULL, NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-20 10:05:09.261', '2026-10-20 10:05:09.261'),
('2b9aca35-07e7-4fce-844f-74bcf136a405', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'discord', 'dd', 'pending', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, '{}', NULL, NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-31 17:58:32.758', '2026-10-31 17:58:32.758'),
('32288852-fbae-4fc0-ba4e-c4a92d12e2b2', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'whatsapp', 'test', 'pending', NULL, 1, '{}', NULL, NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-22 16:52:49.696', '2026-10-22 16:52:49.696'),
('640e8857-0c3f-4aab-9c29-8e2639936cce', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'openwa', 'testChat', 'connected', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, '{}', NULL, NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-22 09:02:35.440', '2026-10-22 09:28:14.925'),
('7fa12482-de20-49e1-ad6b-742e7f58623a', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'website', 'wwww', 'connected', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, '{}', NULL, NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-24 15:49:49.737', '2026-10-24 15:49:49.737'),
('867f36e8-1055-4685-9a2d-62fb410d4b05', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'website', 'Website chat', 'connected', '0d72efde-f505-4f96-ac6d-e04235842656', 1, '{\"title\":\"Botreply Sales\",\"subtitle\":\"Intelligence Behind Every Conversation\",\"greeting\":\"Hi there! How can I help you today?\",\"placeholder\":\"Type a message...\",\"color\":\"#6d28d9\",\"colorEnd\":\"#4f46e5\",\"position\":\"right\",\"suggestions\":[\"How can BotReply help me automate customer conversations online?\",\"Can BotReply automatically qualify leads and capture customer details?\",\"Can I connect my existing WhatsApp Business number to BotReply?\",\"How quickly can I set up BotReply and start getting automated replies?\"],\"contactEmail\":\"support@avpsofttech.com\",\"contactPhone\":\"+91-9368200785\",\"contactWebsite\":\"https://avpsofttech.com\",\"termsUrl\":\"https://avpsofttech.com/terms\",\"privacyUrl\":\"https://avpsofttech.com/privacy\",\"poweredBy\":true}', NULL, NULL, NULL, '2026-10-20 08:57:48.198', '2026-10-24 14:57:46.808'),
('a974ac21-61f4-476f-83c7-3bb797bfe758', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'telegram', 'telegram', 'connected', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, '{}', NULL, NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-29 14:39:07.857', '2026-10-29 14:40:09.195'),
('afaa0c17-bfed-4ff3-a03a-823638a84319', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'website', 'Whatuptes', 'connected', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, '{}', NULL, NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-24 14:58:52.167', '2026-10-24 15:01:17.265'),
('bb543c06-1355-401b-9d52-933b78edf544', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'telegram', 'tesr', 'pending', 'f803b4a0-5da6-4912-ba1d-4a8fb2af9638', 1, '{}', NULL, NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-30 16:33:03.803', '2026-10-30 16:33:03.803'),
('dae48be3-ac91-48a1-b4e6-7323e66afefe', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'openwa', 'WhatsApp (open-wa)', 'error', '0d72efde-f505-4f96-ac6d-e04235842656', 1, '{}', '2026-10-22 10:10:09.653', 'open-wa connect failed: Unable to establish SSE connection', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '2026-10-22 06:00:12.255', '2026-10-24 14:54:36.693');

-- --------------------------------------------------------

--
-- Table structure for table `channel_credentials`
--

CREATE TABLE `channel_credentials` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `channel_id` varchar(36) NOT NULL,
  `secret_enc` text NOT NULL,
  `validation_status` enum('unknown','valid','invalid') NOT NULL DEFAULT 'unknown',
  `last_validated_at` datetime(3) DEFAULT NULL,
  `validation_error` text DEFAULT NULL,
  `updated_by` varchar(36) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `channel_credentials`
--

INSERT INTO `channel_credentials` (`id`, `workspace_id`, `channel_id`, `secret_enc`, `validation_status`, `last_validated_at`, `validation_error`, `updated_by`, `created_at`, `updated_at`) VALUES
('77d2e513-c6a3-415e-9b6f-7aaacba69d78', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'dae48be3-ac91-48a1-b4e6-7323e66afefe', 'v1.3onF2JOz8NfHjeVu.GLh/Wu8ulnudVSr8dZg1CutvHe0ClcQ70s9SEBAlNgdnhuxSGk7LB/NZpE92+50UAEJImPJ7wKAQ0UBS3ZQ3skP9C3Q2Zw5WRvb7L5I=.0+1TImy69LmdbaN4y67twA==', 'unknown', NULL, NULL, NULL, '2026-10-22 06:00:40.564', '2026-10-22 06:00:40.564'),
('fe6db15f-205f-4b65-8c6e-b736b668db84', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '048c105a-3177-4c66-b5ef-32fe95eba2f9', 'v1.jRS09bNY3bQCgyqW.cvKicxeejQHlvURP4GMov5kDyGw1JUzBiut1M7+p3t8mf2XK6FCXczXN7aI/3pbjCbTImXd07dlz2CM8lw==.jA7gaILjZfFRQAXBT28J3A==', 'unknown', NULL, NULL, NULL, '2026-10-31 16:41:44.359', '2026-10-31 16:46:05.574');

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

CREATE TABLE `contacts` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `external_id` varchar(191) DEFAULT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `phone` varchar(64) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `locale` varchar(16) DEFAULT NULL,
  `tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`tags`)),
  `custom_fields` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`custom_fields`)),
  `source` varchar(64) DEFAULT 'manual',
  `consent_status` enum('opted_in','opted_out','unknown') NOT NULL DEFAULT 'unknown',
  `opted_out_at` datetime(3) DEFAULT NULL,
  `opted_out_reason` varchar(191) DEFAULT NULL,
  `last_seen_at` datetime(3) DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `contacts`
--

INSERT INTO `contacts` (`id`, `workspace_id`, `external_id`, `name`, `phone`, `email`, `company`, `locale`, `tags`, `custom_fields`, `source`, `consent_status`, `opted_out_at`, `opted_out_reason`, `last_seen_at`, `created_by`, `created_at`, `updated_at`) VALUES
('09f41452-2b3a-4d4b-8307-976394b3e11c', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', NULL, 'Aarav Sharma', '+911100000001', 'aarav@example.com', NULL, NULL, NULL, NULL, 'website', 'opted_in', NULL, NULL, NULL, NULL, '2026-10-20 08:57:48.198', '2026-10-20 08:57:48.198'),
('ea1295b6-3b81-4a70-ba5b-9ef9895d3d64', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'telegram:6329803387', 'Zoro ⚔️', NULL, NULL, NULL, NULL, NULL, NULL, 'website', 'unknown', NULL, NULL, '2026-10-31 16:49:36.948', NULL, '2026-10-31 16:48:44.831', '2026-10-31 16:49:36.948'),
('f09e2fff-e1bc-4948-82a0-7de08bb0dde7', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '080c0bcd-a2a9-4e28-a2a4-101999336c57', 'Website visitor', NULL, NULL, NULL, NULL, NULL, NULL, 'website', 'unknown', NULL, NULL, '2026-10-20 16:05:43.402', NULL, '2026-10-20 16:05:43.364', '2026-10-20 16:05:43.402');

-- --------------------------------------------------------

--
-- Table structure for table `conversations`
--

CREATE TABLE `conversations` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `channel_id` varchar(36) DEFAULT NULL,
  `contact_id` varchar(36) DEFAULT NULL,
  `agent_id` varchar(36) DEFAULT NULL,
  `agent_version` int(11) DEFAULT NULL,
  `assigned_to` varchar(36) DEFAULT NULL,
  `status` enum('open','pending','resolved','closed') NOT NULL DEFAULT 'open',
  `priority` enum('low','normal','high','urgent') NOT NULL DEFAULT 'normal',
  `human_owned` tinyint(1) NOT NULL DEFAULT 0,
  `ai_paused` tinyint(1) NOT NULL DEFAULT 0,
  `subject` varchar(255) DEFAULT NULL,
  `summary` text DEFAULT NULL,
  `summary_at` datetime(3) DEFAULT NULL,
  `tags` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`tags`)),
  `unread_count` int(11) NOT NULL DEFAULT 0,
  `last_message_at` datetime(3) DEFAULT NULL,
  `last_inbound_at` datetime(3) DEFAULT NULL,
  `closed_at` datetime(3) DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `conversations`
--

INSERT INTO `conversations` (`id`, `workspace_id`, `channel_id`, `contact_id`, `agent_id`, `agent_version`, `assigned_to`, `status`, `priority`, `human_owned`, `ai_paused`, `subject`, `summary`, `summary_at`, `tags`, `unread_count`, `last_message_at`, `last_inbound_at`, `closed_at`, `metadata`, `created_at`, `updated_at`) VALUES
('6fa45e74-50d3-47a7-a74e-79020d0fa2d1', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '867f36e8-1055-4685-9a2d-62fb410d4b05', 'f09e2fff-e1bc-4948-82a0-7de08bb0dde7', '0d72efde-f505-4f96-ac6d-e04235842656', NULL, NULL, 'open', 'normal', 0, 0, NULL, NULL, NULL, NULL, 1, '2026-10-20 16:05:47.488', '2026-10-20 16:05:43.395', NULL, NULL, '2026-10-20 16:05:43.382', '2026-10-20 16:05:47.488'),
('75174959-d544-4410-b7bc-0f232f990a12', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '048c105a-3177-4c66-b5ef-32fe95eba2f9', 'ea1295b6-3b81-4a70-ba5b-9ef9895d3d64', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', NULL, NULL, 'open', 'normal', 0, 0, NULL, NULL, NULL, NULL, 3, '2026-10-31 16:49:42.117', '2026-10-31 16:49:36.937', NULL, '{\"externalId\": \"6329803387\"}', '2026-10-31 16:48:44.842', '2026-10-31 16:49:42.117'),
('fb9d631d-cc26-4afd-84dd-3eca35cf6806', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', NULL, '09f41452-2b3a-4d4b-8307-976394b3e11c', '0d72efde-f505-4f96-ac6d-e04235842656', NULL, NULL, 'open', 'normal', 0, 0, NULL, NULL, NULL, NULL, 0, '2026-10-20 08:57:48.199', '2026-10-20 08:57:48.199', NULL, NULL, '2026-10-20 08:57:48.199', '2026-10-20 08:57:48.199');

-- --------------------------------------------------------

--
-- Table structure for table `customer_accounts`
--

CREATE TABLE `customer_accounts` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `contact_id` varchar(36) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `failed_login_count` int(11) NOT NULL DEFAULT 0,
  `locked_until` datetime(3) DEFAULT NULL,
  `last_login_at` datetime(3) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customer_accounts`
--

INSERT INTO `customer_accounts` (`id`, `workspace_id`, `contact_id`, `email`, `password_hash`, `name`, `failed_login_count`, `locked_until`, `last_login_at`, `created_at`, `updated_at`) VALUES
('b6bcd951-3a35-47b4-a49e-2762121e0c7d', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'f09e2fff-e1bc-4948-82a0-7de08bb0dde7', 'jpal9130@gmail.com', '$2a$10$bg52ucDPPHtq19Z9.4rrh.Hsl/jRYia8wWwBpWijltyXGcoYQbYRK', 'Jatin Pal', 0, NULL, NULL, '2026-10-22 08:51:26.139', '2026-10-22 11:13:21.133');

-- --------------------------------------------------------

--
-- Table structure for table `customer_sessions`
--

CREATE TABLE `customer_sessions` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `customer_account_id` varchar(36) NOT NULL,
  `token_hash` varchar(64) NOT NULL,
  `expires_at` datetime(3) NOT NULL,
  `revoked_at` datetime(3) DEFAULT NULL,
  `last_seen_at` datetime(3) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `ip` varchar(64) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customer_sessions`
--

INSERT INTO `customer_sessions` (`id`, `workspace_id`, `customer_account_id`, `token_hash`, `expires_at`, `revoked_at`, `last_seen_at`, `user_agent`, `ip`, `created_at`) VALUES
('aa90fd0e-dfdb-45ef-b9d1-c189aa2802a9', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'b6bcd951-3a35-47b4-a49e-2762121e0c7d', '140c84f55faf97277ccadb46b4de9ed10ded36e33d5015d3a725c723bb9d940f', '2026-11-21 08:51:26.149', NULL, '2026-10-22 08:51:26.380', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 08:51:26.149');

-- --------------------------------------------------------

--
-- Table structure for table `data_requests`
--

CREATE TABLE `data_requests` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `type` enum('export','deletion') NOT NULL,
  `subject_ref` varchar(191) DEFAULT NULL,
  `status` enum('pending','running','completed','failed') NOT NULL DEFAULT 'pending',
  `requested_by` varchar(36) DEFAULT NULL,
  `result_path` varchar(255) DEFAULT NULL,
  `error` text DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `completed_at` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `data_requests`
--

INSERT INTO `data_requests` (`id`, `workspace_id`, `type`, `subject_ref`, `status`, `requested_by`, `result_path`, `error`, `created_at`, `completed_at`) VALUES
('dr-1', 'ws-1', 'export', 'user-1', 'pending', 'user-1', NULL, NULL, '2026-10-29 14:33:00.341', NULL),
('dr-2', 'ws-2', 'deletion', 'contact-1', 'completed', 'user-2', '/results/deletion-1', NULL, '2026-10-29 14:33:00.341', '2026-10-29 14:33:00.341');

-- --------------------------------------------------------

--
-- Table structure for table `delivery_attempts`
--

CREATE TABLE `delivery_attempts` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `message_id` varchar(36) DEFAULT NULL,
  `campaign_recipient_id` varchar(36) DEFAULT NULL,
  `channel_id` varchar(36) DEFAULT NULL,
  `attempt` int(11) NOT NULL DEFAULT 1,
  `status` enum('sent','failed','rate_limited','rejected') NOT NULL,
  `provider` varchar(32) DEFAULT NULL,
  `provider_message_id` varchar(191) DEFAULT NULL,
  `error` text DEFAULT NULL,
  `provider_response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`provider_response`)),
  `duration_ms` int(11) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `delivery_attempts`
--

INSERT INTO `delivery_attempts` (`id`, `workspace_id`, `message_id`, `campaign_recipient_id`, `channel_id`, `attempt`, `status`, `provider`, `provider_message_id`, `error`, `provider_response`, `duration_ms`, `created_at`) VALUES
('0ebafcda-361a-4d6e-96e5-ccecc7c287b3', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'cb1e7a84-53e7-4a0d-9329-d671f51192c3', NULL, '048c105a-3177-4c66-b5ef-32fe95eba2f9', 1, 'sent', 'telegram', 'tg:4', NULL, NULL, 1288, '2026-10-31 16:49:01.011'),
('3e867baf-4496-46e1-8f55-2fe9ba2580b8', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '7e84e7e1-65f0-42a0-9dad-23ebd7921d02', NULL, '048c105a-3177-4c66-b5ef-32fe95eba2f9', 1, 'sent', 'telegram', 'tg:6', NULL, NULL, 750, '2026-10-31 16:49:43.650'),
('becc9c5f-fe3d-438d-9da4-49d9ae59779d', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'b39e763f-4372-472f-9787-7965d62439fb', NULL, '048c105a-3177-4c66-b5ef-32fe95eba2f9', 1, 'sent', 'telegram', 'tg:3', NULL, NULL, 810, '2026-10-31 16:48:51.125'),
('e71f74b7-9a7b-4636-b976-80f365e69dd5', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'c15dd075-fa40-4a72-8294-540398befae5', NULL, '867f36e8-1055-4685-9a2d-62fb410d4b05', 1, 'sent', 'website', NULL, NULL, NULL, 4, '2026-10-20 16:05:48.272');

-- --------------------------------------------------------

--
-- Table structure for table `flows`
--

CREATE TABLE `flows` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `status` enum('draft','published','archived') NOT NULL DEFAULT 'draft',
  `current_version` int(11) NOT NULL DEFAULT 0,
  `trigger_config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`trigger_config`)),
  `created_by` varchar(36) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `flows`
--

INSERT INTO `flows` (`id`, `workspace_id`, `name`, `description`, `status`, `current_version`, `trigger_config`, `created_by`, `created_at`, `updated_at`) VALUES
('6e84e2c2-dcc5-44b4-b613-6fedef216458', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'abc', 'test test', 'draft', 1, '{\"type\":\"message.received\"}', '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-20 10:48:27.473', '2026-10-20 11:33:11.824'),
('flow-1', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'Lead Qualification', 'Automatically qualify leads through a series of questions', 'published', 0, '{\"kind\":\"new_contact\"}', 'flow-1', '2026-10-30 11:01:43.073', '2026-10-30 11:01:43.073'),
('flow-2', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'Support Ticket Creation', 'Create a support ticket when a customer issue is detected', 'published', 2, '{\"type\":\"message.received\"}', 'flow-2', '2026-10-30 11:01:43.081', '2026-10-30 14:24:37.590');

-- --------------------------------------------------------

--
-- Table structure for table `flow_runs`
--

CREATE TABLE `flow_runs` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `flow_id` varchar(36) NOT NULL,
  `flow_version_id` varchar(36) NOT NULL,
  `conversation_id` varchar(36) DEFAULT NULL,
  `contact_id` varchar(36) DEFAULT NULL,
  `status` enum('running','waiting','completed','failed','cancelled') NOT NULL DEFAULT 'running',
  `context` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`context`)),
  `current_node` varchar(64) DEFAULT NULL,
  `wait_until` datetime(3) DEFAULT NULL,
  `wait_node` varchar(64) DEFAULT NULL,
  `input` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`input`)),
  `error` text DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `finished_at` datetime(3) DEFAULT NULL,
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `flow_steps`
--

CREATE TABLE `flow_steps` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `run_id` varchar(36) NOT NULL,
  `node_id` varchar(64) NOT NULL,
  `node_type` varchar(48) NOT NULL,
  `status` enum('started','succeeded','failed','skipped') NOT NULL,
  `input` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`input`)),
  `output` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`output`)),
  `error` text DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `finished_at` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `flow_versions`
--

CREATE TABLE `flow_versions` (
  `id` varchar(36) NOT NULL,
  `flow_id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `version` int(11) NOT NULL,
  `status` enum('draft','published','archived') NOT NULL DEFAULT 'draft',
  `definition` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`definition`)),
  `published_at` datetime(3) DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `flow_versions`
--

INSERT INTO `flow_versions` (`id`, `flow_id`, `workspace_id`, `version`, `status`, `definition`, `published_at`, `created_by`, `created_at`) VALUES
('71825d29-5290-4eb7-8fea-210ca5d09a4f', '6e84e2c2-dcc5-44b4-b613-6fedef216458', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 1, 'draft', '{\"nodes\":[{\"id\":\"start\",\"type\":\"start\",\"label\":\"Start\"}],\"edges\":[]}', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-20 10:48:27.497'),
('dbf2e647-01a3-4eaa-98da-3daa104602f1', 'flow-2', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 2, 'draft', '{\"nodes\":[{\"id\":\"start\",\"type\":\"trigger\",\"label\":\"start\",\"x\":24,\"y\":24},{\"id\":\"analyze\",\"type\":\"ai\",\"label\":\"analyze\",\"x\":268,\"y\":24},{\"id\":\"create-ticket\",\"type\":\"action\",\"label\":\"create-ticket\",\"x\":512,\"y\":24},{\"id\":\"end\",\"type\":\"end\",\"label\":\"end\",\"x\":583.5556030273438,\"y\":268.4444885253906},{\"id\":\"message-1\",\"type\":\"message\",\"label\":\"Message\",\"x\":166.22222900390625,\"y\":160.88894653320312},{\"id\":\"condition-1\",\"type\":\"condition\",\"label\":\"Condition\",\"x\":1000,\"y\":24}],\"edges\":[{\"from\":\"start\",\"to\":\"analyze\"},{\"from\":\"analyze\",\"to\":\"create-ticket\"},{\"from\":\"create-ticket\",\"to\":\"end\"}]}', NULL, '59627376-d414-4b33-a8c5-756cf5d231a1', '2026-10-30 14:24:26.006'),
('flow-1', 'flow-1', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 1, 'published', '{\"nodes\":[{\"id\":\"start\",\"type\":\"trigger\",\"input\":{}},{\"id\":\"question1\",\"type\":\"question\",\"input\":{\"question\":\"What is your company size?\"}},{\"id\":\"question2\",\"type\":\"question\",\"input\":{\"question\":\"What is your budget?\"}},{\"id\":\"end\",\"type\":\"end\",\"input\":{}}],\"edges\":[{\"from\":\"start\",\"to\":\"question1\"},{\"from\":\"question1\",\"to\":\"question2\"},{\"from\":\"question2\",\"to\":\"end\"}]}', NULL, 'flow-1', '2026-10-30 11:01:43.078'),
('flow-2', 'flow-2', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 1, 'published', '{\"nodes\":[{\"id\":\"start\",\"type\":\"trigger\",\"input\":{}},{\"id\":\"analyze\",\"type\":\"ai\",\"input\":{\"task\":\"analyze issue\"}},{\"id\":\"create-ticket\",\"type\":\"action\",\"input\":{\"action\":\"create_ticket\"}},{\"id\":\"end\",\"type\":\"end\",\"input\":{}}],\"edges\":[{\"from\":\"start\",\"to\":\"analyze\"},{\"from\":\"analyze\",\"to\":\"create-ticket\"},{\"from\":\"create-ticket\",\"to\":\"end\"}]}', '2026-10-30 14:22:19.522', 'flow-2', '2026-10-30 11:01:43.091');

-- --------------------------------------------------------

--
-- Table structure for table `handoffs`
--

CREATE TABLE `handoffs` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `conversation_id` varchar(36) NOT NULL,
  `from_agent_id` varchar(36) DEFAULT NULL,
  `to_user_id` varchar(36) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `requested_by` varchar(36) DEFAULT NULL,
  `status` enum('pending','accepted','auto_accepted') NOT NULL DEFAULT 'pending',
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `resolved_at` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `idempotency_keys`
--

CREATE TABLE `idempotency_keys` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `scope` varchar(96) NOT NULL,
  `idem_key` varchar(191) NOT NULL,
  `request_hash` varchar(64) NOT NULL,
  `status` enum('in_progress','completed') NOT NULL DEFAULT 'in_progress',
  `response` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`response`)),
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `completed_at` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `idempotency_keys`
--

INSERT INTO `idempotency_keys` (`id`, `workspace_id`, `scope`, `idem_key`, `request_hash`, `status`, `response`, `created_at`, `completed_at`) VALUES
('ik-1', 'ws-1', 'api_call', 'idem-1', 'reqhash-1', 'completed', '{\"result\": \"success\"}', '2026-10-29 14:33:00.318', '2026-10-29 14:33:00.318'),
('ik-2', 'ws-2', 'api_call', 'idem-2', 'reqhash-2', 'in_progress', NULL, '2026-10-29 14:33:00.318', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `industry_templates`
--

CREATE TABLE `industry_templates` (
  `id` varchar(36) NOT NULL,
  `industry` varchar(64) NOT NULL,
  `label` varchar(120) NOT NULL,
  `description` varchar(500) NOT NULL,
  `purpose` varchar(200) DEFAULT NULL,
  `tone` varchar(60) NOT NULL DEFAULT 'friendly',
  `welcome_message` varchar(500) DEFAULT NULL,
  `persona` text DEFAULT NULL,
  `faqs` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`faqs`)),
  `agent_type` varchar(24) NOT NULL DEFAULT 'custom',
  `safety_rules` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`safety_rules`)),
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `industry_templates`
--

INSERT INTO `industry_templates` (`id`, `industry`, `label`, `description`, `purpose`, `tone`, `welcome_message`, `persona`, `faqs`, `agent_type`, `safety_rules`, `created_at`, `updated_at`) VALUES
('tpl-automotive', 'automotive-services', 'Automotive services', 'Service bookings, pricing, and workshop availability.', 'Book services and explain service packages', 'friendly', 'Hello! I can help you book a service, check pricing, or find workshop timings. How can I help?', 'You are a helpful automotive service assistant. Answer service package, pricing, and workshop timing questions from the knowledge base, and book service appointments with the available tools. Confirm vehicle model and preferred slot before booking, and route technical fault-diagnosis questions to a workshop engineer.', '[{\"question\":\"How much does a periodic service cost?\",\"answer\":\"Service package prices depend on the vehicle model. Tell me your car\'s model and I will share the applicable package.\"},{\"question\":\"Can I book a service for tomorrow?\",\"answer\":\"Let me check availability. Which vehicle are you bringing, and what time of day suits you?\"},{\"question\":\"How long does the service take?\",\"answer\":\"Typical service durations are listed here. Share your vehicle model and the service type for the estimate.\"}]', 'booking', NULL, '2026-10-30 20:22:44.129', '2026-10-30 20:22:44.129'),
('tpl-ecommerce', 'ecommerce-retail', 'E-commerce and retail', 'Order status, returns, refunds, product questions, and delivery info.', 'Help customers with orders, returns, refunds, and product questions', 'friendly', 'Hi there! I can help you track an order, start a return, or find the right product. What do you need today?', 'You are a friendly e-commerce support assistant. Answer order status, delivery, returns, refunds, and product questions from the knowledge base and the available tools. Offer next steps proactively, capture contact details when you cannot resolve, and present the return or refund conditions exactly as the store policy states.', '[{\"question\":\"How long does delivery take?\",\"answer\":\"Delivery timelines depend on your location and are listed in the shipping policy. Share your city and order details and I will check.\"},{\"question\":\"What is your return policy?\",\"answer\":\"Here is the return policy as the store has published it. Tell me your order id and I will walk you through the steps.\"},{\"question\":\"Where is my order?\",\"answer\":\"I can check that. Please share the order id you used at checkout.\"}]', 'support', NULL, '2026-10-30 20:22:44.129', '2026-10-30 20:22:44.129'),
('tpl-education', 'education-schools', 'Education and schools', 'Admissions, fees, courses, and school timings.', 'Answer admission, course, and fee questions for students and parents', 'friendly', 'Hi! Welcome to our school assistant. I can help with admissions, courses, fees, and timings.', 'You are a warm and organized school assistant. Answer questions about admissions, courses, fees, schedules, and school policies strictly from the knowledge base. Encourage prospective parents to submit an application or visit, and politely hand off anything requiring a teacher or registrar.', '[{\"question\":\"How do I apply for admission?\",\"answer\":\"Admission steps and deadlines are listed here. Would you like me to guide you through the requirements?\"},{\"question\":\"What are the school timings?\",\"answer\":\"Timings differ by grade and are included in the school profile. Which grade is your child joining?\"},{\"question\":\"What is the fee structure?\",\"answer\":\"The current fee schedule is on file. Tell me the grade or program and I will share the details.\"}]', 'support', NULL, '2026-10-30 20:22:44.129', '2026-10-30 20:22:44.129'),
('tpl-finance', 'finance-accounting', 'Finance and accounting', 'Service information, document requirements, and appointment booking.', 'Explain services and requirements; book consultations', 'professional', 'Hello! I can explain our services, required documents, and help you book a consultation. What do you need?', 'You are a precise finance-office assistant. Explain services, document requirements, fee schedules, and timelines strictly from the knowledge base, and book consultations. You are not a licensed advisor: never give investment, tax mitigation, or legal advice; route anything requiring professional judgment to a human advisor.', '[{\"question\":\"What documents do I need for registration?\",\"answer\":\"The checklist is listed here. Tell me the service you need and I will share the exact requirements.\"},{\"question\":\"How much does your service cost?\",\"answer\":\"The current fee schedule is on file. Which service are you interested in?\"},{\"question\":\"Can I get advice on my taxes?\",\"answer\":\"I can book a consultation with an advisor for anything that needs professional judgment. Would you like me to schedule one?\"}]', 'booking', '[\"Never provide investment, tax planning, or legal advice; route to a licensed advisor\"]', '2026-10-30 20:22:44.129', '2026-10-30 20:22:44.129'),
('tpl-general', 'general-support', 'General customer support', 'FAQs, service information, and human-handoff support for any business.', 'Answer customer questions and escalate to humans when needed', 'friendly', 'Hi! I am your customer support assistant. Ask me anything about our services or products.', 'You are a helpful customer support assistant for this business. Answer questions strictly from the knowledge base, be concise, and clearly say when something is not available. Create tickets or capture leads when appropriate, and connect a human teammate when the customer asks or the matter is sensitive.', '[]', 'custom', NULL, '2026-10-30 20:22:44.129', '2026-10-30 20:22:44.129'),
('tpl-healthcare', 'healthcare-clinics', 'Healthcare and clinics', 'Clinic hours, services, doctor information, and appointment requests.', 'Help patients get clinic information and book appointments', 'caring', 'Hello! Welcome to our clinic assistant. I can help you with timings, services, and appointment requests. How can I help today?', 'You are a discreet, empathetic clinic assistant. Answer questions about timings, services, doctors, and appointment availability strictly from the knowledge base. You may help book or request appointments. You are not a medical professional: never diagnose, never recommend medication or treatment, and route any clinical, urgent, or emergency concern to staff or emergency services immediately.', '[{\"question\":\"What are your opening hours?\",\"answer\":\"Our clinic timings are updated in the knowledge base and shown on this assistant. Tell me your preferred day and I will check availability for you.\"},{\"question\":\"How can I book an appointment?\",\"answer\":\"I can help you request an appointment anytime. Which service or doctor would you like to see, and what day and time suit you?\"},{\"question\":\"Where are you located?\",\"answer\":\"Our address and directions are listed here. Would you like directions or the contact number as well?\"}]', 'booking', '[\"Never give medical diagnosis, treatment, or medication advice\",\"Route emergency keywords (chest pain, bleeding, suicide, emergency) to emergency services and a human staff member\",\"Collect only the minimum information needed to book an appointment\"]', '2026-10-30 20:22:44.129', '2026-10-30 20:22:44.129'),
('tpl-homecare', 'home-healthcare', 'Home healthcare', 'Available services, service-area inquiries, and care booking requests.', 'Explain care services and book care visits', 'caring', 'Hello! I can help you understand our home care services, coverage, and book a care visit. How can I help you today?', 'You are a caring home-healthcare assistant. Explain available care services, service areas, visit durations, and pricing strictly from the knowledge base, and schedule care visits or assessments. You are not a medical professional: never give medical, nursing, or medication advice, collect only the minimum information needed to schedule, and route any urgent or clinical concern to on-call medical staff or emergency services.', '[{\"question\":\"What services do you provide at home?\",\"answer\":\"Services include daily-living assistance, post-operative care, elder care, and nursing visits. Tell me the patient\'s need and I will suggest the right service.\"},{\"question\":\"Do you cover my area?\",\"answer\":\"Our service areas are listed here. Share your locality and I will confirm coverage.\"},{\"question\":\"How do I book a care visit?\",\"answer\":\"I can schedule it now. What date and time suit you, and what kind of care is needed?\"}]', 'booking', '[\"Never give medical, nursing, or medication advice\",\"Route emergency or urgent-clinical concerns to medical staff or emergency services\",\"Collect minimum necessary information for scheduling\"]', '2026-10-30 20:22:44.129', '2026-10-30 20:22:44.129'),
('tpl-hr', 'hr-recruitment', 'HR and recruitment', 'Recruitment FAQs, job openings, and application status.', 'Answer candidate questions about openings and applications', 'professional', 'Hi! I can help you find open roles, understand the hiring process, or check your application. How can I help?', 'You are a neutral, professional recruitment assistant. Share current openings, hiring stages, and role requirements strictly from the knowledge base. Keep all answers fact-based and non-discriminatory, decline to speculate on screening decisions, and route salary negotiation or confidential matters to a human recruiter.', '[{\"question\":\"What roles are currently open?\",\"answer\":\"Current openings are listed here. Tell me your field of experience and I will highlight the best match.\"},{\"question\":\"What is the hiring process?\",\"answer\":\"The standard process is described here: application, screening interview(s), and final decision. Which role are you applying for?\"},{\"question\":\"How can I check my application status?\",\"answer\":\"Share the email or reference id you applied with and I will help you check where it stands.\"}]', 'hr', NULL, '2026-10-30 20:22:44.129', '2026-10-30 20:22:44.129'),
('tpl-legal', 'legal-services', 'Legal services', 'Practice areas, consultation booking, and document requirements.', 'Explain practice areas and book consultations', 'professional', 'Hello! I can help you understand our practice areas, required documents, and book a consultation. How can I help?', 'You are a professional and discreet law-office assistant. Describe practice areas, the consultation process, document requirements, and fees strictly from the knowledge base, and book consultations. You are not a lawyer: never give legal advice or opinions on a case; route any legal-matter question to an advocate and recommend the appropriate consultation.', '[{\"question\":\"What practice areas do you handle?\",\"answer\":\"Our practice areas are listed here. Briefly tell me the nature of your matter and I will suggest the right team.\"},{\"question\":\"What are your consultation fees?\",\"answer\":\"The current fee schedule is on file. Which kind of consultation do you need: initial or case review?\"},{\"question\":\"What documents should I bring?\",\"answer\":\"Document checklists depend on the matter type. Tell me the area of law and I will share the checklist.\"}]', 'booking', '[\"Never provide legal advice or case opinions; route all legal-matter questions to a professional\"]', '2026-10-30 20:22:44.129', '2026-10-30 20:22:44.129'),
('tpl-logistics', 'logistics-delivery', 'Logistics and delivery', 'Shipment status, service areas, pricing, and pickup scheduling.', 'Help customers track shipments and schedule pickups', 'concise', 'Hi! I can help track a shipment, check a service area, or schedule a pickup. What do you need?', 'You are an efficient logistics support assistant. Answer shipment tracking, service-area coverage, pricing, and pickup scheduling questions from the knowledge base and tools. Be concise and factual; if tracking data is unavailable, explain the reason and create a ticket for the operations team.', '[{\"question\":\"Where is my shipment?\",\"answer\":\"Share your tracking or consignment id and I will check its current status.\"},{\"question\":\"Do you deliver to my area?\",\"answer\":\"Our service areas are listed here. Tell me the pin code or city and I will confirm coverage.\"},{\"question\":\"How are charges calculated?\",\"answer\":\"Pricing is based on weight, distance, and service level. Share the route details and I will quote the applicable rates.\"}]', 'support', NULL, '2026-10-30 20:22:44.129', '2026-10-30 20:22:44.129'),
('tpl-manufacturing', 'manufacturing', 'Manufacturing', 'Product catalogs, quotations, specifications, and order inquiries.', 'Help distributors and buyers with products and quotes', 'professional', 'Welcome! I can help with products, specifications, and quotation requests. What can I look up for you?', 'You are a B2B manufacturing assistant. Answer product specifications, minimum order quantities, lead times, and pricing strictly from the knowledge base. Qualify the buyer\'s company and requirement, record qualified inquiries with the lead tool, and route custom engineering questions to the technical team.', '[{\"question\":\"What is your minimum order quantity?\",\"answer\":\"MOQ varies by product. Tell me which product or category you need and I will share the requirement.\"},{\"question\":\"What are your lead times?\",\"answer\":\"Standard lead times are listed per product line. What product and quantity are you planning?\"},{\"question\":\"Can you send a quotation?\",\"answer\":\"I can start that. Please share the product, quantity, and your company details.\"}]', 'sales', NULL, '2026-10-30 20:22:44.129', '2026-10-30 20:22:44.129'),
('tpl-realestate', 'real-estate', 'Real estate', 'Property listings, lead qualification, site visits, and callback requests.', 'Qualify property buyers and schedule site visits', 'professional', 'Welcome! I can help you explore properties, book a site visit, or arrange a callback. What are you looking for?', 'You are a professional real-estate assistant. Qualify leads by asking about location preference, budget, property type, and timeline, one question at a time. Share property and pricing information strictly from the knowledge base, offer site visits with available timings, record every qualified prospect with the lead tool, and log accurate preferences.', '[{\"question\":\"Do you have 2BHK apartments available?\",\"answer\":\"I can help with that. Which area are you looking in, and what is your budget range?\"},{\"question\":\"Can I schedule a site visit?\",\"answer\":\"Absolutely. Which property are you interested in, and what day and time work for you?\"},{\"question\":\"What are the payment plans?\",\"answer\":\"Payment plans vary by project and are on file. Which project or locality are you considering?\"}]', 'sales', NULL, '2026-10-30 20:22:44.129', '2026-10-30 20:22:44.129'),
('tpl-travel', 'travel-hospitality', 'Travel and hospitality', 'Booking help, packages, policies, and itinerary questions.', 'Help guests with bookings, packages, and stay information', 'warm', 'Hello, and welcome! I can help with rooms, packages, policies, and your stay. How may I help you today?', 'You are a warm, attentive travel and hospitality assistant. Answer questions about accommodation, packages, availability, amenities, and cancellation policies strictly from the knowledge base, and assist with bookings using the available tools. Confirm all details before completing a booking and route special requests to the property manager when needed.', '[{\"question\":\"Do you have rooms available this weekend?\",\"answer\":\"Let me help. How many guests, and do you prefer standard rooms or a package?\"},{\"question\":\"What is your cancellation policy?\",\"answer\":\"The cancellation policy for your booking type is listed here. Would you like the summary for standard or prepaid rates?\"},{\"question\":\"What facilities do you offer?\",\"answer\":\"Our amenities are listed here: rooms, dining, and guest services. What is most important for your stay?\"}]', 'booking', NULL, '2026-10-30 20:22:44.129', '2026-10-30 20:22:44.129');

-- --------------------------------------------------------

--
-- Table structure for table `ingestion_jobs`
--

CREATE TABLE `ingestion_jobs` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `source_id` varchar(36) NOT NULL,
  `kind` enum('ingest','reindex','delete','url_sync') NOT NULL DEFAULT 'ingest',
  `status` enum('queued','running','succeeded','failed','cancelled') NOT NULL DEFAULT 'queued',
  `attempts` int(11) NOT NULL DEFAULT 0,
  `progress` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`progress`)),
  `error` text DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `started_at` datetime(3) DEFAULT NULL,
  `finished_at` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ingestion_jobs`
--

INSERT INTO `ingestion_jobs` (`id`, `workspace_id`, `source_id`, `kind`, `status`, `attempts`, `progress`, `error`, `created_at`, `started_at`, `finished_at`) VALUES
('0e7d5b03-3d8f-453e-87ea-5e40df78427d', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'source-1', 'ingest', 'failed', 0, NULL, 'Uploaded file is missing from storage', '2026-10-30 14:09:39.487', '2026-10-30 14:09:39.487', '2026-10-30 14:09:39.491'),
('2f94e16b-5f00-42df-a44c-5178cf4d1676', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'source-1', 'ingest', 'failed', 0, NULL, 'Uploaded file is missing from storage', '2026-10-30 14:09:28.903', '2026-10-30 14:09:28.903', '2026-10-30 14:09:28.913'),
('7ca2c12b-98fe-408d-9f12-cc8e3e081080', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'source-1', 'ingest', 'failed', 0, NULL, 'Uploaded file is missing from storage', '2026-10-30 14:09:31.176', '2026-10-30 14:09:31.176', '2026-10-30 14:09:31.180'),
('95d910f5-2ba9-46e0-995e-7e11dedb69f3', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'source-1', 'ingest', 'failed', 0, NULL, 'Uploaded file is missing from storage', '2026-10-30 14:09:32.690', '2026-10-30 14:09:32.690', '2026-10-30 14:09:32.695'),
('97be7adf-6220-48fd-ab2f-049ea35d5b15', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'source-1', 'ingest', 'failed', 0, NULL, 'Uploaded file is missing from storage', '2026-10-30 14:09:37.223', '2026-10-30 14:09:37.223', '2026-10-30 14:09:37.228'),
('9ad82a8d-3527-4e70-989d-43fe3d554312', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'ec2603eb-7ce9-48d0-8e6c-59193a7da3a6', 'ingest', 'failed', 0, NULL, 'Column count doesn\'t match value count at row 1', '2026-10-30 11:22:07.742', '2026-10-30 11:22:07.742', '2026-10-30 11:22:07.747'),
('beafad71-0413-4c0e-ae24-3a1acf1aa6bc', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'ec2603eb-7ce9-48d0-8e6c-59193a7da3a6', 'ingest', 'failed', 0, NULL, 'Column count doesn\'t match value count at row 1', '2026-10-30 11:22:04.646', '2026-10-30 11:22:04.646', '2026-10-30 11:22:04.683'),
('dd99113f-91b2-442b-ac53-87cca6fbfd30', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'ec2603eb-7ce9-48d0-8e6c-59193a7da3a6', 'ingest', 'failed', 0, NULL, 'Column count doesn\'t match value count at row 1', '2026-10-30 11:22:13.772', '2026-10-30 11:22:13.772', '2026-10-30 11:22:13.784'),
('f0863b20-39d5-4194-b517-954dcf9c383d', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'source-1', 'ingest', 'failed', 0, NULL, 'Uploaded file is missing from storage', '2026-10-30 14:09:34.202', '2026-10-30 14:09:34.202', '2026-10-30 14:09:34.206');

-- --------------------------------------------------------

--
-- Table structure for table `invitations`
--

CREATE TABLE `invitations` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `email` varchar(255) NOT NULL,
  `role` enum('owner','admin','manager','agent','analyst','viewer') NOT NULL,
  `token_hash` varchar(64) NOT NULL,
  `invited_by` varchar(36) NOT NULL,
  `expires_at` datetime(3) NOT NULL,
  `accepted_at` datetime(3) DEFAULT NULL,
  `revoked_at` datetime(3) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `invitations`
--

INSERT INTO `invitations` (`id`, `workspace_id`, `email`, `role`, `token_hash`, `invited_by`, `expires_at`, `accepted_at`, `revoked_at`, `created_at`) VALUES
('inv-1', 'ws-1', 'invite1@example.com', 'admin', 'token-test-1-hash', 'user-1', '2026-11-05 14:33:00.299', NULL, NULL, '2026-10-29 14:33:00.299'),
('inv-2', 'ws-2', 'invite2@example.com', '', 'token-test-2-hash', 'user-2', '2026-11-05 14:33:00.299', NULL, NULL, '2026-10-29 14:33:00.299');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` varchar(36) NOT NULL,
  `queue` varchar(64) NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`payload`)),
  `status` enum('queued','running','succeeded','failed','dead','cancelled') NOT NULL DEFAULT 'queued',
  `attempts` int(11) NOT NULL DEFAULT 0,
  `max_attempts` int(11) NOT NULL DEFAULT 5,
  `run_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `locked_by` varchar(64) DEFAULT NULL,
  `locked_at` datetime(3) DEFAULT NULL,
  `last_error` text DEFAULT NULL,
  `dedupe_key` varchar(191) DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT 100,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jobs`
--

INSERT INTO `jobs` (`id`, `queue`, `payload`, `status`, `attempts`, `max_attempts`, `run_at`, `locked_by`, `locked_at`, `last_error`, `dedupe_key`, `priority`, `created_at`, `updated_at`) VALUES
('1a5cd31e-2d34-49ac-bf0c-c81dc9a2c8cc', 'inbound-messaging', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"channelId\":\"048c105a-3177-4c66-b5ef-32fe95eba2f9\",\"provider\":\"telegram\",\"externalMessageId\":\"5\",\"externalConversationId\":\"6329803387\",\"body\":\"please provide the information of bot reply paln\",\"contact\":{\"externalId\":\"telegram:6329803387\",\"name\":\"Zoro ⚔️\"},\"metadata\":{\"chatType\":\"private\",\"updateId\":164872744}}', 'succeeded', 1, 5, '2026-10-31 16:49:36.879', NULL, '2026-10-31 16:49:36.898', NULL, NULL, 100, '2026-10-31 16:49:36.880', '2026-10-31 16:49:36.972'),
('1b536ddc-4f7f-40de-9114-702706ad7c14', 'outbound-delivery', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"conversationId\":\"75174959-d544-4410-b7bc-0f232f990a12\",\"messageId\":\"b39e763f-4372-472f-9787-7965d62439fb\",\"channelId\":\"048c105a-3177-4c66-b5ef-32fe95eba2f9\",\"agentId\":\"96600822-c3a4-4bca-85ce-4faeda9b7a8b\",\"body\":\"Hello! I\'m your sales assistant. I can help you with product information, pricing, or any questions you have about our services.\\n\\nTo point you in the right direction, what brings you here today? Are you looking for a specific solution, or just exploring your options?\",\"outboxId\":\"e943b71b-1ff0-4a1a-a5f0-cbd5347b4075\"}', 'succeeded', 1, 5, '2026-10-31 16:48:50.239', NULL, '2026-10-31 16:48:50.246', NULL, NULL, 100, '2026-10-31 16:48:50.241', '2026-10-31 16:48:51.131'),
('1d1a0888-7480-4ded-9248-92aecd750cd1', 'campaign-delivery', '{\"campaignId\":\"eea185ab-60f9-4421-9269-04a2dfcb05b0\",\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\"}', 'succeeded', 1, 5, '2026-10-24 14:55:32.396', NULL, '2026-10-24 14:55:33.111', NULL, 'campaign-delivery:eea185ab-60f9-4421-9269-04a2dfcb05b0', 100, '2026-10-24 14:55:32.397', '2026-10-24 14:55:33.646'),
('3872bf4b-6356-4974-852b-89c887616d90', 'outbound-delivery', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"conversationId\":\"6fa45e74-50d3-47a7-a74e-79020d0fa2d1\",\"messageId\":\"c15dd075-fa40-4a72-8294-540398befae5\",\"channelId\":\"867f36e8-1055-4685-9a2d-62fb410d4b05\",\"agentId\":\"0d72efde-f505-4f96-ac6d-e04235842656\",\"body\":\"BotReply helps automate customer conversations by handling common questions, routing messages, and providing quick replies across online channels. It can reduce response time, keep conversations consistent, and free up your team for more complex issues.\\n\\nTypical uses:\\n- Answer FAQs automatically\\n- Qualify leads\\n- Route chats to the right team\\n- Send instant replies after hours\\n\\nIf you want, I can also help you turn this into a short product description, sales pitch, or support reply.\",\"outboxId\":\"9eafe0e0-dd2d-436c-bc85-7d9d38fa5e17\"}', 'succeeded', 1, 5, '2026-10-20 16:05:48.252', NULL, '2026-10-20 16:05:48.256', NULL, NULL, 100, '2026-10-20 16:05:48.253', '2026-10-20 16:05:48.282'),
('3f1083ea-c7b0-4e1a-914d-d1e317b695fa', 'outbound-delivery', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"conversationId\":\"75174959-d544-4410-b7bc-0f232f990a12\",\"messageId\":\"7e84e7e1-65f0-42a0-9dad-23ebd7921d02\",\"channelId\":\"048c105a-3177-4c66-b5ef-32fe95eba2f9\",\"agentId\":\"96600822-c3a4-4bca-85ce-4faeda9b7a8b\",\"body\":\"I apologize, but I don\'t have information regarding a \\\"bot reply plan\\\" in my current records. \\n\\nTo ensure you get the most accurate details, I can have one of our team members reach out to you directly. Would you like to leave your contact information, or would you prefer to speak with a human representative now?\",\"outboxId\":\"0697ec98-7371-4d3c-b7e5-d7eb3b6afd24\"}', 'succeeded', 1, 5, '2026-10-31 16:49:42.882', NULL, '2026-10-31 16:49:42.890', NULL, NULL, 100, '2026-10-31 16:49:42.883', '2026-10-31 16:49:43.656'),
('55cb546f-987e-45a2-82f6-42eaefe962a3', 'ai-execution', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"conversationId\":\"75174959-d544-4410-b7bc-0f232f990a12\",\"inboundMessageId\":\"a94e6fa5-95de-4a48-bbae-80d1195481d8\",\"channelId\":\"048c105a-3177-4c66-b5ef-32fe95eba2f9\",\"outboxId\":\"5ba0b031-0697-49ab-9dfc-8bcdd39c1774\"}', 'succeeded', 1, 5, '2026-10-31 16:49:37.774', NULL, '2026-10-31 16:49:37.780', NULL, NULL, 100, '2026-10-31 16:49:37.775', '2026-10-31 16:49:42.125'),
('5846c450-e5df-4307-a9d3-63b2ef6246d1', 'campaign-delivery', '{\"campaignId\":\"79a798b2-9629-4b78-b500-55f871688992\",\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\"}', 'succeeded', 1, 5, '2026-10-24 15:06:33.636', NULL, '2026-10-24 15:06:34.247', NULL, NULL, 100, '2026-10-24 15:06:33.637', '2026-10-24 15:06:34.771'),
('5d37acf7-0e9c-4527-97f3-e544b2400791', 'outbound-delivery', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"conversationId\":\"75174959-d544-4410-b7bc-0f232f990a12\",\"messageId\":\"cb1e7a84-53e7-4a0d-9329-d671f51192c3\",\"channelId\":\"048c105a-3177-4c66-b5ef-32fe95eba2f9\",\"agentId\":\"96600822-c3a4-4bca-85ce-4faeda9b7a8b\",\"body\":\"Hi there! How can I help you today? Are you looking for information on a specific product, or do you have questions about our services? I\'m here to help you find the right solution.\",\"outboxId\":\"e8c22446-51e5-48ca-a2a2-7878838f751a\"}', 'succeeded', 1, 5, '2026-10-31 16:48:59.713', NULL, '2026-10-31 16:48:59.718', NULL, NULL, 100, '2026-10-31 16:48:59.714', '2026-10-31 16:49:01.017'),
('6a4d2725-41dc-4cf4-bce5-a662c63278f3', 'ai-execution', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"conversationId\":\"75174959-d544-4410-b7bc-0f232f990a12\",\"inboundMessageId\":\"f4a561ec-c386-4d4a-85da-da31641ae656\",\"channelId\":\"048c105a-3177-4c66-b5ef-32fe95eba2f9\",\"outboxId\":\"3b056aef-bf07-4061-bce0-e806626fa057\"}', 'succeeded', 1, 5, '2026-10-31 16:48:56.697', NULL, '2026-10-31 16:48:56.701', NULL, NULL, 100, '2026-10-31 16:48:56.698', '2026-10-31 16:48:58.197'),
('6e1256fd-bd02-4bf5-901f-23acf3dcd92f', 'ai-execution', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"conversationId\":\"75174959-d544-4410-b7bc-0f232f990a12\",\"inboundMessageId\":\"99b35a05-faed-42dd-b806-91f9b9897367\",\"channelId\":\"048c105a-3177-4c66-b5ef-32fe95eba2f9\",\"outboxId\":\"125d13d9-f372-4736-9974-6ef878102d41\"}', 'succeeded', 1, 5, '2026-10-31 16:48:45.651', NULL, '2026-10-31 16:48:45.654', NULL, NULL, 100, '2026-10-31 16:48:45.652', '2026-10-31 16:48:49.481'),
('98325cb8-3bd1-4be8-884e-f76ff87a1fe1', 'knowledge-ingestion', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"sourceId\":\"source-1\",\"kind\":\"reindex\"}', 'dead', 3, 3, '2026-10-30 14:09:36.757', NULL, '2026-10-30 14:09:37.214', 'Error: Uploaded file is missing from storage', 'knowledge:source-1:reindex:1793369368774', 100, '2026-10-30 14:09:28.776', '2026-10-30 14:09:37.229'),
('a199e507-39c4-479b-bf56-0ba44d067cfc', 'campaign-delivery', '{\"campaignId\":\"0e94f491-bbf8-47be-995a-fa76dfaa7a33\",\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\"}', 'succeeded', 1, 5, '2026-10-24 15:13:49.126', NULL, '2026-10-24 15:13:49.422', NULL, NULL, 100, '2026-10-24 15:13:49.129', '2026-10-24 15:13:49.428'),
('a2eeae35-ec9e-4a6f-81d3-34d4f91ed835', 'inbound-messaging', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"channelId\":\"048c105a-3177-4c66-b5ef-32fe95eba2f9\",\"provider\":\"telegram\",\"externalMessageId\":\"1\",\"externalConversationId\":\"6329803387\",\"body\":\"/start\",\"contact\":{\"externalId\":\"telegram:6329803387\",\"name\":\"Zoro ⚔️\"},\"metadata\":{\"chatType\":\"private\",\"updateId\":164872742}}', 'succeeded', 1, 5, '2026-10-31 16:48:44.794', NULL, '2026-10-31 16:48:44.813', NULL, NULL, 100, '2026-10-31 16:48:44.797', '2026-10-31 16:48:44.896'),
('a977e55e-b3f3-4934-ba18-2950f920b2a6', 'knowledge-ingestion', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"sourceId\":\"ec2603eb-7ce9-48d0-8e6c-59193a7da3a6\",\"kind\":\"ingest\"}', 'dead', 3, 3, '2026-10-30 11:22:13.194', NULL, '2026-10-30 11:22:13.768', 'Error: Column count doesn\'t match value count at row 1', 'knowledge:ec2603eb-7ce9-48d0-8e6c-59193a7da3a6:ingest', 100, '2026-10-30 11:22:04.276', '2026-10-30 11:22:13.787'),
('ac3492ec-1356-48a8-a574-3eaea445a92b', 'campaign-delivery', '{\"campaignId\":\"b8db83db-f793-46b8-84f7-cac890467a37\",\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\"}', 'succeeded', 1, 5, '2026-10-24 15:03:06.640', NULL, '2026-10-24 15:03:06.902', NULL, NULL, 100, '2026-10-24 15:03:06.646', '2026-10-24 15:03:07.457'),
('c5331e38-51f3-4d3c-9743-17e60aa89427', 'campaign-delivery', '{\"campaignId\":\"1cada601-5845-4665-817f-4f54af2d6a66\",\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\"}', 'succeeded', 1, 5, '2026-10-24 16:18:58.236', NULL, '2026-10-24 16:18:58.876', NULL, NULL, 100, '2026-10-24 15:18:58.270', '2026-10-24 16:18:58.884'),
('d0954dd2-870e-41cd-a267-cdc1d56d0d6b', 'campaign-delivery', '{\"campaignId\":\"a960368e-d6f1-485f-b4d6-52a8f8082840\",\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\"}', 'succeeded', 1, 5, '2026-10-30 11:55:49.787', NULL, '2026-10-30 11:55:49.888', NULL, NULL, 100, '2026-10-30 11:55:49.788', '2026-10-30 11:55:50.160'),
('d3fc6820-f515-4663-988f-182cf27f2b47', 'knowledge-ingestion', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"sourceId\":\"source-1\",\"kind\":\"reindex\"}', 'dead', 3, 3, '2026-10-30 14:09:39.133', NULL, '2026-10-30 14:09:39.485', 'Error: Uploaded file is missing from storage', 'knowledge:source-1:reindex:1793369370682', 100, '2026-10-30 14:09:30.683', '2026-10-30 14:09:39.492'),
('e010c036-658d-4d14-9de7-a59e6de26e35', 'inbound-messaging', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"channelId\":\"048c105a-3177-4c66-b5ef-32fe95eba2f9\",\"provider\":\"telegram\",\"externalMessageId\":\"2\",\"externalConversationId\":\"6329803387\",\"body\":\"hi\",\"contact\":{\"externalId\":\"telegram:6329803387\",\"name\":\"Zoro ⚔️\"},\"metadata\":{\"chatType\":\"private\",\"updateId\":164872743}}', 'succeeded', 1, 5, '2026-10-31 16:48:54.347', NULL, '2026-10-31 16:48:54.362', NULL, NULL, 100, '2026-10-31 16:48:54.348', '2026-10-31 16:48:54.431'),
('e9964351-a79c-40b7-a943-a547310601e5', 'campaign-delivery', '{\"campaignId\":\"13e39da4-595c-482f-926c-304f034f0771\",\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\"}', 'succeeded', 1, 5, '2026-10-24 15:13:49.190', NULL, '2026-10-24 15:13:49.424', NULL, NULL, 100, '2026-10-24 15:13:49.191', '2026-10-24 15:13:49.430'),
('fb95804a-4c18-44e2-a14c-558a6c0ac6d2', 'ai-execution', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"conversationId\":\"6fa45e74-50d3-47a7-a74e-79020d0fa2d1\",\"inboundMessageId\":\"db1ebcb4-1248-4013-afa0-61b795c1780c\",\"channelId\":\"867f36e8-1055-4685-9a2d-62fb410d4b05\",\"outboxId\":\"af6dcca6-1c83-414f-bf0f-e079b8fa067b\"}', 'succeeded', 1, 5, '2026-10-20 16:05:44.275', NULL, '2026-10-20 16:05:44.317', NULL, NULL, 100, '2026-10-20 16:05:44.293', '2026-10-20 16:05:47.495'),
('j-1', 'default', '{\"type\": \"send_message\"}', 'queued', 0, 5, '2026-10-29 14:33:00.335', NULL, NULL, NULL, 'dedupe-1', 100, '2026-10-29 14:33:00.335', '2026-10-29 14:33:00.335'),
('j-2', 'high', '{\"type\": \"export_data\"}', 'running', 0, 5, '2026-10-29 14:33:00.335', NULL, NULL, NULL, 'dedupe-2', 200, '2026-10-29 14:33:00.335', '2026-10-29 14:33:00.335');

-- --------------------------------------------------------

--
-- Table structure for table `knowledge_chunks`
--

CREATE TABLE `knowledge_chunks` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `source_id` varchar(36) NOT NULL,
  `chunk_index` int(11) NOT NULL,
  `content` text NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `token_count` int(11) NOT NULL DEFAULT 0,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `embedding` mediumblob DEFAULT NULL,
  `embedding_model` varchar(96) DEFAULT NULL,
  `embedding_dim` int(11) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `knowledge_chunks`
--

INSERT INTO `knowledge_chunks` (`id`, `workspace_id`, `source_id`, `chunk_index`, `content`, `title`, `token_count`, `metadata`, `embedding`, `embedding_model`, `embedding_dim`, `created_at`) VALUES
('0b96271c-54fd-47bd-857f-05833b1d56cf', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'source-2', 1, 'Support is available 24/7 via email and chat. Enterprise plans include phone support.', 'Support Hours', 35, NULL, NULL, NULL, NULL, '2026-10-30 11:07:11.842'),
('51b2fc8e-366e-42b4-afd4-f3a985a06dbc', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'source-2', 0, 'Our pricing starts at $99/month for the Basic plan. Pro plan is $299/month with advanced features.', 'Pricing', 40, NULL, NULL, NULL, NULL, '2026-10-30 11:07:11.803'),
('a2e9e3ec-91eb-407b-b5a5-136a6f04e256', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'source-1', 1, 'To install BotReply, follow these steps: 1. Download the package, 2. Run the installer, 3. Configure your settings.', 'Installation', 80, NULL, NULL, NULL, NULL, '2026-10-30 11:07:11.798'),
('b275fd39-885e-451c-a825-28fa6ba7689f', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'source-1', 0, 'Welcome to BotReply! This document explains how to get started with our platform.', 'Getting Started', 50, NULL, NULL, NULL, NULL, '2026-10-30 11:07:11.763');

-- --------------------------------------------------------

--
-- Table structure for table `knowledge_sources`
--

CREATE TABLE `knowledge_sources` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` enum('pdf','docx','txt','markdown','csv','json','html','htm','url','faq','product','text') NOT NULL,
  `status` enum('pending','processing','ready','failed','deleting') NOT NULL DEFAULT 'pending',
  `file_path` varchar(500) DEFAULT NULL,
  `file_size` int(11) DEFAULT NULL,
  `mime` varchar(128) DEFAULT NULL,
  `url` varchar(1000) DEFAULT NULL,
  `config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`config`)),
  `version` int(11) NOT NULL DEFAULT 1,
  `chunk_count` int(11) NOT NULL DEFAULT 0,
  `indexed_chunks` int(11) NOT NULL DEFAULT 0,
  `error` text DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `processed_at` datetime(3) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `knowledge_sources`
--

INSERT INTO `knowledge_sources` (`id`, `workspace_id`, `name`, `type`, `status`, `file_path`, `file_size`, `mime`, `url`, `config`, `version`, `chunk_count`, `indexed_chunks`, `error`, `created_by`, `processed_at`, `created_at`, `updated_at`) VALUES
('ec2603eb-7ce9-48d0-8e6c-59193a7da3a6', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'Services', 'text', 'failed', NULL, NULL, NULL, NULL, '{\"itemType\":\"service\",\"tags\":[\"hr\",\"payroll\"],\"attributes\":[{\"name\":\"eligibility\",\"value\":\"11\"}],\"allowAgentToSend\":false,\"text\":\"Service: Services\\n\\ntestt  HR\"}', 1, 0, 0, 'Column count doesn\'t match value count at row 1', '59627376-d414-4b33-a8c5-756cf5d231a1', NULL, '2026-10-30 11:22:04.272', '2026-10-30 11:22:13.778'),
('source-1', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'Product Documentation', 'docx', 'failed', NULL, NULL, NULL, NULL, '{\"language\":\"en\"}', 3, 0, 0, 'Uploaded file is missing from storage', NULL, NULL, '2026-10-30 11:01:43.051', '2026-10-30 14:09:39.490'),
('source-2', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'FAQ', 'faq', 'ready', NULL, NULL, NULL, NULL, '{\"language\":\"en\"}', 1, 0, 0, NULL, NULL, NULL, '2026-10-30 11:01:43.056', '2026-10-30 11:01:43.056');

-- --------------------------------------------------------

--
-- Table structure for table `leads`
--

CREATE TABLE `leads` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `contact_id` varchar(36) DEFAULT NULL,
  `conversation_id` varchar(36) DEFAULT NULL,
  `source` enum('conversation','form','indiamart','tradeindia','manual','workflow','campaign','website') NOT NULL DEFAULT 'manual',
  `external_enquiry_id` varchar(191) DEFAULT NULL,
  `product_interest` varchar(255) DEFAULT NULL,
  `quantity` varchar(64) DEFAULT NULL,
  `enquiry_message` text DEFAULT NULL,
  `status` enum('new','contacted','qualified','proposal','won','lost') NOT NULL DEFAULT 'new',
  `priority` enum('low','normal','high','urgent') NOT NULL DEFAULT 'normal',
  `owner_user_id` varchar(36) DEFAULT NULL,
  `follow_up_at` datetime(3) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `conversion_value` double DEFAULT NULL,
  `converted_at` datetime(3) DEFAULT NULL,
  `ingestion_status` enum('received','enriched','engaged','failed') NOT NULL DEFAULT 'received',
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lead_stage_history`
--

CREATE TABLE `lead_stage_history` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `lead_id` varchar(36) NOT NULL,
  `from_status` varchar(32) DEFAULT NULL,
  `to_status` varchar(32) NOT NULL,
  `changed_by` varchar(36) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `marketplace_cursors`
--

CREATE TABLE `marketplace_cursors` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `channel_id` varchar(36) NOT NULL,
  `provider` varchar(32) NOT NULL,
  `cursor_state` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`cursor_state`)),
  `last_polled_at` datetime(3) DEFAULT NULL,
  `last_success_at` datetime(3) DEFAULT NULL,
  `status` enum('idle','running','error') NOT NULL DEFAULT 'idle',
  `error` text DEFAULT NULL,
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `marketplace_cursors`
--

INSERT INTO `marketplace_cursors` (`id`, `workspace_id`, `channel_id`, `provider`, `cursor_state`, `last_polled_at`, `last_success_at`, `status`, `error`, `updated_at`) VALUES
('0418d039-bfcf-4833-8001-86ce926178a0', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'bb543c06-1355-401b-9d52-933b78edf544', 'telegram', '{}', NULL, NULL, 'idle', NULL, '2026-10-30 16:33:03.812'),
('5cc36ae8-df4c-4889-80fb-1f5aa53b77e7', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '28ba790c-b54a-483b-861c-aaa0dc4e24ae', 'whatsapp', '{}', NULL, NULL, 'idle', NULL, '2026-10-20 10:05:09.271'),
('95dc787a-6aa8-4da6-b3ba-7e578fb89864', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '048c105a-3177-4c66-b5ef-32fe95eba2f9', 'telegram', '{}', NULL, NULL, 'idle', NULL, '2026-10-31 16:41:44.380'),
('b101386a-d135-4e41-b9ae-690adbe6adda', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'a974ac21-61f4-476f-83c7-3bb797bfe758', 'telegram', '{}', NULL, NULL, 'idle', NULL, '2026-10-29 14:39:07.869'),
('b46d0a48-5417-4cc9-94e4-53d85f294456', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '32288852-fbae-4fc0-ba4e-c4a92d12e2b2', 'whatsapp', '{}', NULL, NULL, 'idle', NULL, '2026-10-22 16:52:49.707'),
('c08c7e71-ac71-4e56-909d-43577a86dc1e', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '640e8857-0c3f-4aab-9c29-8e2639936cce', 'openwa', '{}', NULL, NULL, 'idle', NULL, '2026-10-22 09:02:35.449'),
('e23485e3-5f80-446e-a4c4-219c515e9863', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '2b9aca35-07e7-4fce-844f-74bcf136a405', 'discord', '{}', NULL, NULL, 'idle', NULL, '2026-10-31 17:58:32.768'),
('ec48452d-1eb3-45dd-a97b-7b49b1ff7a63', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'dae48be3-ac91-48a1-b4e6-7323e66afefe', 'openwa', '{}', NULL, NULL, 'idle', NULL, '2026-10-22 06:00:12.263');

-- --------------------------------------------------------

--
-- Table structure for table `memberships`
--

CREATE TABLE `memberships` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `role` enum('owner','admin','manager','agent','analyst','viewer') NOT NULL,
  `status` enum('active','suspended') NOT NULL DEFAULT 'active',
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `memberships`
--

INSERT INTO `memberships` (`id`, `workspace_id`, `user_id`, `role`, `status`, `created_at`, `updated_at`) VALUES
('95c92db6-38b8-45c8-bc8c-6ae610b6e4b7', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '8658f0fc-a05a-4123-9061-cb7b45878e04', 'manager', 'active', '2026-10-20 08:59:41.487', '2026-10-20 08:59:41.487'),
('a5dfe04d-0c8a-4883-94b7-a6fd4d81429c', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'f5a31fab-043e-4859-8a46-ac19fb67796d', 'agent', 'active', '2026-10-20 08:59:41.562', '2026-10-20 08:59:41.562'),
('b11077a7-9b3e-4df8-b611-c087c8ac8f3a', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'admin', 'active', '2026-10-20 08:59:41.414', '2026-10-20 08:59:41.414'),
('b89887ee-f74d-4db0-9caf-055ed969f69d', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'owner', 'active', '2026-10-20 08:57:48.195', '2026-10-20 08:57:48.195'),
('c2bbdb1d-a950-4fc3-a577-42080694b406', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '567797f6-c8d3-4ea0-b53a-19838a82f44a', 'viewer', 'active', '2026-10-20 08:59:41.728', '2026-10-20 08:59:41.728'),
('e02a14fe-a268-4928-8665-b4c8d90334fd', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '4a566cd7-129e-420b-bb95-4c2e11b29b99', 'analyst', 'active', '2026-10-20 08:59:41.631', '2026-10-20 08:59:41.631'),
('e459a998-3191-4f89-b760-1219802b80b1', '951f0dbc-1a1f-44ed-aa74-e828ee8d6953', '78f88de2-49db-4994-9db3-4e190abefe46', 'owner', 'active', '2026-10-22 08:52:46.137', '2026-10-22 08:52:46.137'),
('mem-1', 'ws-1', 'user-1', 'owner', 'active', '2026-10-29 14:33:00.274', '2026-10-29 14:33:00.274'),
('mem-2', 'ws-1', 'user-2', 'admin', 'active', '2026-10-29 14:33:00.274', '2026-10-29 14:33:00.274'),
('mem-3', 'ws-1', 'user-3', '', 'active', '2026-10-29 14:33:00.274', '2026-10-29 14:33:00.274'),
('mem-4', 'ws-2', 'user-2', 'owner', 'active', '2026-10-29 14:33:00.274', '2026-10-29 14:33:00.274'),
('mem-5', 'ws-2', 'user-3', 'admin', 'active', '2026-10-29 14:33:00.274', '2026-10-29 14:33:00.274'),
('mem-6', 'ws-3', 'user-3', 'owner', 'active', '2026-10-29 14:33:00.274', '2026-10-29 14:33:00.274'),
('mem-7', 'ws-3', 'user-1', 'admin', 'active', '2026-10-29 14:33:00.274', '2026-10-29 14:33:00.274'),
('mem-8', 'ws-3', 'user-2', 'manager', 'active', '2026-10-29 14:33:00.274', '2026-10-29 14:33:00.274');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `conversation_id` varchar(36) NOT NULL,
  `direction` enum('inbound','outbound','internal') NOT NULL,
  `sender_type` enum('contact','user','agent','bot','system') NOT NULL,
  `sender_id` varchar(36) DEFAULT NULL,
  `body` text NOT NULL,
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`content`)),
  `status` enum('queued','sent','delivered','read','failed','received') NOT NULL DEFAULT 'received',
  `provider` varchar(32) DEFAULT NULL,
  `provider_message_id` varchar(191) DEFAULT NULL,
  `error` text DEFAULT NULL,
  `dedupe_key` varchar(191) DEFAULT NULL,
  `agent_id` varchar(36) DEFAULT NULL,
  `agent_version` int(11) DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `workspace_id`, `conversation_id`, `direction`, `sender_type`, `sender_id`, `body`, `content`, `status`, `provider`, `provider_message_id`, `error`, `dedupe_key`, `agent_id`, `agent_version`, `metadata`, `created_at`) VALUES
('6f0b7bf6-fbc7-4320-9f2d-0d606cb89764', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'fb9d631d-cc26-4afd-84dd-3eca35cf6806', 'inbound', 'contact', NULL, 'Hi, do you ship to Pune?', NULL, 'received', 'website', NULL, NULL, NULL, NULL, NULL, NULL, '2026-10-20 08:57:48.200'),
('7e84e7e1-65f0-42a0-9dad-23ebd7921d02', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '75174959-d544-4410-b7bc-0f232f990a12', 'outbound', 'bot', NULL, 'I apologize, but I don\'t have information regarding a \"bot reply plan\" in my current records. \n\nTo ensure you get the most accurate details, I can have one of our team members reach out to you directly. Would you like to leave your contact information, or would you prefer to speak with a human representative now?', NULL, 'sent', 'telegram', 'tg:6', NULL, 'ai:a94e6fa5-95de-4a48-bbae-80d1195481d8', NULL, 1, NULL, '2026-10-31 16:49:42.111'),
('99b35a05-faed-42dd-b806-91f9b9897367', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '75174959-d544-4410-b7bc-0f232f990a12', 'inbound', 'contact', NULL, '/start', NULL, 'received', 'telegram', '1', NULL, 'telegram:1', NULL, NULL, '{\"chatType\":\"private\",\"updateId\":164872742}', '2026-10-31 16:48:44.848'),
('a94e6fa5-95de-4a48-bbae-80d1195481d8', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '75174959-d544-4410-b7bc-0f232f990a12', 'inbound', 'contact', NULL, 'please provide the information of bot reply paln', NULL, 'received', 'telegram', '5', NULL, 'telegram:5', NULL, NULL, '{\"chatType\":\"private\",\"updateId\":164872744}', '2026-10-31 16:49:36.921'),
('b39e763f-4372-472f-9787-7965d62439fb', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '75174959-d544-4410-b7bc-0f232f990a12', 'outbound', 'bot', NULL, 'Hello! I\'m your sales assistant. I can help you with product information, pricing, or any questions you have about our services.\n\nTo point you in the right direction, what brings you here today? Are you looking for a specific solution, or just exploring your options?', NULL, 'sent', 'telegram', 'tg:3', NULL, 'ai:99b35a05-faed-42dd-b806-91f9b9897367', NULL, 1, NULL, '2026-10-31 16:48:49.461'),
('c15dd075-fa40-4a72-8294-540398befae5', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '6fa45e74-50d3-47a7-a74e-79020d0fa2d1', 'outbound', 'bot', NULL, 'BotReply helps automate customer conversations by handling common questions, routing messages, and providing quick replies across online channels. It can reduce response time, keep conversations consistent, and free up your team for more complex issues.\n\nTypical uses:\n- Answer FAQs automatically\n- Qualify leads\n- Route chats to the right team\n- Send instant replies after hours\n\nIf you want, I can also help you turn this into a short product description, sales pitch, or support reply.', NULL, 'sent', 'website', NULL, NULL, 'ai:db1ebcb4-1248-4013-afa0-61b795c1780c', NULL, 1, NULL, '2026-10-20 16:05:47.482'),
('cb1e7a84-53e7-4a0d-9329-d671f51192c3', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '75174959-d544-4410-b7bc-0f232f990a12', 'outbound', 'bot', NULL, 'Hi there! How can I help you today? Are you looking for information on a specific product, or do you have questions about our services? I\'m here to help you find the right solution.', NULL, 'sent', 'telegram', 'tg:4', NULL, 'ai:f4a561ec-c386-4d4a-85da-da31641ae656', NULL, 1, NULL, '2026-10-31 16:48:58.188'),
('db1ebcb4-1248-4013-afa0-61b795c1780c', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '6fa45e74-50d3-47a7-a74e-79020d0fa2d1', 'inbound', 'contact', NULL, 'How can BotReply help me automate customer conversations online?', NULL, 'received', 'website', NULL, NULL, 'widget:867f36e8-1055-4685-9a2d-62fb410d4b05:cw-1792512343300-ur4be4', NULL, NULL, '{\"visitorId\":\"080c0bcd-a2a9-4e28-a2a4-101999336c57\"}', '2026-10-20 16:05:43.388'),
('f4a561ec-c386-4d4a-85da-da31641ae656', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '75174959-d544-4410-b7bc-0f232f990a12', 'inbound', 'contact', NULL, 'hi', NULL, 'received', 'telegram', '2', NULL, 'telegram:2', NULL, NULL, '{\"chatType\":\"private\",\"updateId\":164872743}', '2026-10-31 16:48:54.369');

-- --------------------------------------------------------

--
-- Table structure for table `message_attachments`
--

CREATE TABLE `message_attachments` (
  `message_id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `source_id` varchar(36) DEFAULT NULL,
  `file_path` varchar(500) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `mime` varchar(128) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `contact_id` varchar(36) DEFAULT NULL,
  `conversation_id` varchar(36) DEFAULT NULL,
  `order_number` varchar(64) NOT NULL,
  `status` enum('draft','confirmed','processing','shipped','delivered','cancelled','refunded') NOT NULL DEFAULT 'draft',
  `currency` char(3) NOT NULL DEFAULT 'INR',
  `subtotal` double NOT NULL DEFAULT 0,
  `discount` double NOT NULL DEFAULT 0,
  `tax` double NOT NULL DEFAULT 0,
  `total` double NOT NULL DEFAULT 0,
  `external_ref` varchar(191) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `order_id` varchar(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `sku` varchar(96) DEFAULT NULL,
  `quantity` double NOT NULL DEFAULT 1,
  `unit_price` double NOT NULL DEFAULT 0,
  `total` double NOT NULL DEFAULT 0,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_status_history`
--

CREATE TABLE `order_status_history` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `order_id` varchar(36) NOT NULL,
  `from_status` varchar(32) DEFAULT NULL,
  `to_status` varchar(32) NOT NULL,
  `changed_by` varchar(36) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `outbox_events`
--

CREATE TABLE `outbox_events` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) DEFAULT NULL,
  `topic` varchar(96) NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`payload`)),
  `status` enum('pending','dispatched','failed') NOT NULL DEFAULT 'pending',
  `attempts` int(11) NOT NULL DEFAULT 0,
  `available_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `last_error` text DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `dispatched_at` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `outbox_events`
--

INSERT INTO `outbox_events` (`id`, `workspace_id`, `topic`, `payload`, `status`, `attempts`, `available_at`, `last_error`, `created_at`, `dispatched_at`) VALUES
('0697ec98-7371-4d3c-b7e5-d7eb3b6afd24', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'message.outbound', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"conversationId\":\"75174959-d544-4410-b7bc-0f232f990a12\",\"messageId\":\"7e84e7e1-65f0-42a0-9dad-23ebd7921d02\",\"channelId\":\"048c105a-3177-4c66-b5ef-32fe95eba2f9\",\"agentId\":\"96600822-c3a4-4bca-85ce-4faeda9b7a8b\",\"body\":\"I apologize, but I don\'t have information regarding a \\\"bot reply plan\\\" in my current records. \\n\\nTo ensure you get the most accurate details, I can have one of our team members reach out to you directly. Would you like to leave your contact information, or would you prefer to speak with a human representative now?\"}', 'dispatched', 1, '2026-10-31 16:49:42.121', NULL, '2026-10-31 16:49:42.121', '2026-10-31 16:49:42.880'),
('125d13d9-f372-4736-9974-6ef878102d41', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'conversation.ai-turn', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"conversationId\":\"75174959-d544-4410-b7bc-0f232f990a12\",\"inboundMessageId\":\"99b35a05-faed-42dd-b806-91f9b9897367\",\"channelId\":\"048c105a-3177-4c66-b5ef-32fe95eba2f9\"}', 'dispatched', 1, '2026-10-31 16:48:44.891', NULL, '2026-10-31 16:48:44.891', '2026-10-31 16:48:45.650'),
('3b056aef-bf07-4061-bce0-e806626fa057', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'conversation.ai-turn', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"conversationId\":\"75174959-d544-4410-b7bc-0f232f990a12\",\"inboundMessageId\":\"f4a561ec-c386-4d4a-85da-da31641ae656\",\"channelId\":\"048c105a-3177-4c66-b5ef-32fe95eba2f9\"}', 'dispatched', 1, '2026-10-31 16:48:54.428', NULL, '2026-10-31 16:48:54.428', '2026-10-31 16:48:56.688'),
('5ba0b031-0697-49ab-9dfc-8bcdd39c1774', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'conversation.ai-turn', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"conversationId\":\"75174959-d544-4410-b7bc-0f232f990a12\",\"inboundMessageId\":\"a94e6fa5-95de-4a48-bbae-80d1195481d8\",\"channelId\":\"048c105a-3177-4c66-b5ef-32fe95eba2f9\"}', 'dispatched', 1, '2026-10-31 16:49:36.961', NULL, '2026-10-31 16:49:36.961', '2026-10-31 16:49:37.766'),
('9eafe0e0-dd2d-436c-bc85-7d9d38fa5e17', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'message.outbound', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"conversationId\":\"6fa45e74-50d3-47a7-a74e-79020d0fa2d1\",\"messageId\":\"c15dd075-fa40-4a72-8294-540398befae5\",\"channelId\":\"867f36e8-1055-4685-9a2d-62fb410d4b05\",\"agentId\":\"0d72efde-f505-4f96-ac6d-e04235842656\",\"body\":\"BotReply helps automate customer conversations by handling common questions, routing messages, and providing quick replies across online channels. It can reduce response time, keep conversations consistent, and free up your team for more complex issues.\\n\\nTypical uses:\\n- Answer FAQs automatically\\n- Qualify leads\\n- Route chats to the right team\\n- Send instant replies after hours\\n\\nIf you want, I can also help you turn this into a short product description, sales pitch, or support reply.\"}', 'dispatched', 1, '2026-10-20 16:05:47.490', NULL, '2026-10-20 16:05:47.490', '2026-10-20 16:05:48.250'),
('af6dcca6-1c83-414f-bf0f-e079b8fa067b', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'conversation.ai-turn', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"conversationId\":\"6fa45e74-50d3-47a7-a74e-79020d0fa2d1\",\"inboundMessageId\":\"db1ebcb4-1248-4013-afa0-61b795c1780c\",\"channelId\":\"867f36e8-1055-4685-9a2d-62fb410d4b05\"}', 'dispatched', 1, '2026-10-20 16:05:43.411', NULL, '2026-10-20 16:05:43.411', '2026-10-20 16:05:44.233'),
('e8c22446-51e5-48ca-a2a2-7878838f751a', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'message.outbound', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"conversationId\":\"75174959-d544-4410-b7bc-0f232f990a12\",\"messageId\":\"cb1e7a84-53e7-4a0d-9329-d671f51192c3\",\"channelId\":\"048c105a-3177-4c66-b5ef-32fe95eba2f9\",\"agentId\":\"96600822-c3a4-4bca-85ce-4faeda9b7a8b\",\"body\":\"Hi there! How can I help you today? Are you looking for information on a specific product, or do you have questions about our services? I\'m here to help you find the right solution.\"}', 'dispatched', 1, '2026-10-31 16:48:58.194', NULL, '2026-10-31 16:48:58.194', '2026-10-31 16:48:59.702'),
('e943b71b-1ff0-4a1a-a5f0-cbd5347b4075', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'message.outbound', '{\"workspaceId\":\"a046f159-d232-41ac-a686-a88e8f9ff2b5\",\"conversationId\":\"75174959-d544-4410-b7bc-0f232f990a12\",\"messageId\":\"b39e763f-4372-472f-9787-7965d62439fb\",\"channelId\":\"048c105a-3177-4c66-b5ef-32fe95eba2f9\",\"agentId\":\"96600822-c3a4-4bca-85ce-4faeda9b7a8b\",\"body\":\"Hello! I\'m your sales assistant. I can help you with product information, pricing, or any questions you have about our services.\\n\\nTo point you in the right direction, what brings you here today? Are you looking for a specific solution, or just exploring your options?\"}', 'dispatched', 1, '2026-10-31 16:48:49.478', NULL, '2026-10-31 16:48:49.478', '2026-10-31 16:48:50.237'),
('oe-1', 'ws-1', 'email', '{\"to\": \"test@example.com\", \"subject\": \"Test\", \"body\": \"Hello\"}', 'dispatched', 1, '2026-10-29 14:33:00.336', NULL, '2026-10-29 14:33:00.336', '2026-10-29 14:33:02.304'),
('oe-2', 'ws-2', 'webhook', '{\"event\": \"test\", \"data\": \"{}\"}', 'dispatched', 1, '2026-10-29 14:33:00.336', NULL, '2026-10-29 14:33:00.336', '2026-10-29 14:33:00.336');

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `token_hash` varchar(64) NOT NULL,
  `expires_at` datetime(3) NOT NULL,
  `used_at` datetime(3) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `password_resets`
--

INSERT INTO `password_resets` (`id`, `user_id`, `token_hash`, `expires_at`, `used_at`, `created_at`) VALUES
('pr-1', 'user-1', 'reset-token-1', '2026-10-30 14:33:00.307', NULL, '2026-10-29 14:33:00.307');

-- --------------------------------------------------------

--
-- Table structure for table `refresh_sessions`
--

CREATE TABLE `refresh_sessions` (
  `id` varchar(36) NOT NULL,
  `user_id` varchar(36) NOT NULL,
  `token_hash` varchar(64) NOT NULL,
  `expires_at` datetime(3) NOT NULL,
  `revoked_at` datetime(3) DEFAULT NULL,
  `rotated_from` varchar(36) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `ip` varchar(64) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `refresh_sessions`
--

INSERT INTO `refresh_sessions` (`id`, `user_id`, `token_hash`, `expires_at`, `revoked_at`, `rotated_from`, `user_agent`, `ip`, `created_at`) VALUES
('00b0c499-59fb-4a6c-b0ed-c5084f3ac7d4', '59627376-d414-4b33-a8c5-756cf5d231a1', 'f8363e88eab77b62754f588e6cf2d7cae37f796c5f57fc94991ed6006311e6cb', '2026-11-23 14:49:17.622', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 14:49:17.622'),
('01363cac-2534-4d55-b1d4-ec8cde8cb45b', '59627376-d414-4b33-a8c5-756cf5d231a1', '7d873c6d1a6902712480420655afe3237fa6e401ef7a5fe7b79e9895046c79c5', '2026-11-29 11:36:45.251', '2026-10-30 11:53:22.341', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 11:36:45.251'),
('03b8035a-e6e6-4735-bc0d-0499b701604c', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'c2561fc7195dfcc2af9647f40b345edd2ead2db1cdc453047f311dab3cbd4be3', '2026-11-30 16:41:43.986', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-31 16:41:43.986'),
('0ac7fb6d-094f-42a5-8ea7-fc5c0ef115c8', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'e657572711958950bf5f21d07c9fb824eb46e52a986a0cf3c917c325b663378d', '2026-11-21 08:22:05.339', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::ffff:127.0.0.1', '2026-10-22 08:22:05.339'),
('0ba0003c-de31-413b-a97f-9eef216ded3f', '59627376-d414-4b33-a8c5-756cf5d231a1', '17e4e67f686147d1f74d3cc6bcc5ba6f51a9a85303740a5a6815b1cb01b2608a', '2026-11-30 15:44:17.568', '2026-10-31 16:42:06.828', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-31 15:44:17.568'),
('0dcfb3f0-f219-4635-a43f-2446cc697fcc', '59627376-d414-4b33-a8c5-756cf5d231a1', '493bb47cdb7996e15e9eca3a6e855178f4011da11d4fb370b7a54eca39997963', '2026-11-19 09:00:46.048', '2026-10-20 09:09:11.751', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 09:00:46.048'),
('0ed0b253-a3e2-41fc-94af-75dc16a767b0', '59627376-d414-4b33-a8c5-756cf5d231a1', '56eb42e70922597b788cb31b54d2058e7e7c835b4a4808d5c47aa580331be269', '2026-11-21 09:09:36.364', '2026-10-22 09:28:14.872', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 09:09:36.364'),
('0ef4dd6b-ad0b-42c0-8148-c17c9f850b98', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '06ce9800aa5508960731dd8f647365d239812aad31f7cb6a8e03da766617d751', '2026-11-23 15:06:33.468', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-24 15:06:33.468'),
('1080cd98-d382-4da0-a60b-eb1369edfd80', '59627376-d414-4b33-a8c5-756cf5d231a1', '0a6b78870667c1c4302757f3a043365fe02666b5526c2a9c2ef594dc705658d3', '2026-11-23 15:26:13.836', '2026-10-24 15:43:38.615', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 15:26:13.836'),
('1461f991-a1df-47ab-a548-4e3acb4d8a94', '59627376-d414-4b33-a8c5-756cf5d231a1', 'fa6d96d57eb34bcd3c51d485776775d54c5ff553b8f68eb449b6aa7487ad63ac', '2026-11-23 15:59:08.731', '2026-10-24 16:25:37.019', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 15:59:08.731'),
('160fb19f-2028-4c65-a4d8-daad011f213a', '59627376-d414-4b33-a8c5-756cf5d231a1', '3ce63ddd05ec00158a950369c15dbeb2fec9521a9b23b5fb62f12c04fe33dce9', '2026-11-21 09:09:36.362', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 09:09:36.362'),
('166fe29c-bc1d-4384-92cd-196db5bfe2bd', '59627376-d414-4b33-a8c5-756cf5d231a1', '6fa14c82e2e3961d9b0fbfe02b97370ffdac3f3c0cc114139f903ba6dcb1909c', '2026-11-19 10:17:45.454', '2026-10-20 10:18:50.178', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 10:17:45.454'),
('16d8f986-f697-4f93-a85d-012f19dd0f73', '59627376-d414-4b33-a8c5-756cf5d231a1', 'f0ae2dc03eefb1d42ee648b29a45ed509e7778aa346797d0e182d903235b04d9', '2026-11-29 13:58:54.377', '2026-10-30 14:14:25.719', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 13:58:54.377'),
('180bfd13-430a-46b8-9105-771995af51cc', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '9c9d63edaad25a62df54525422d7de815e597b2278e268c95b0f2e6d8e111046', '2026-11-26 10:34:35.883', NULL, NULL, 'node', '::ffff:127.0.0.1', '2026-10-27 10:34:35.883'),
('182bf820-3a2c-4985-8f7b-fa16ff3ac06b', '59627376-d414-4b33-a8c5-756cf5d231a1', 'ce9f3d41dcaf79e98769c7d457040ef04e04475d1a462e14e84b588521b37c3c', '2026-11-19 09:36:37.943', '2026-10-20 09:40:07.501', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 09:36:37.943'),
('195a7a0b-3559-431b-8316-a6243ffe0444', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '96ddddb86bbdcdb48fb7a616cc75ce5886e15a6e047f38b3f655ddcbe5fd9f51', '2026-11-21 10:40:29.424', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-22 10:40:29.424'),
('1a47d224-7504-40e8-8c54-0c8bc1738007', '59627376-d414-4b33-a8c5-756cf5d231a1', 'a2c46066bd209961bcb168b319144359b7254f70da83deafa7485576b7afad05', '2026-11-21 12:53:40.372', '2026-10-22 13:09:24.740', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 12:53:40.372'),
('1f35d746-4022-402e-a2db-3fe3856e0248', '59627376-d414-4b33-a8c5-756cf5d231a1', 'f84a4779fb921f94456a84a8d22f7eaa00a94dd766f625b325707fe5d35b7cef', '2026-11-23 15:08:38.222', '2026-10-24 15:25:14.420', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 15:08:38.222'),
('22eaa6e9-2761-4053-a589-99e9ce6a9c24', '59627376-d414-4b33-a8c5-756cf5d231a1', 'd21b41bdf9d1f6663bc7d0ec17cd9e3437465057d2cf2e5b1ad1b83a2e4646b5', '2026-11-29 14:51:04.226', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 14:51:04.226'),
('23a0755d-46c3-47a0-ab35-ab6ca91d4c38', '59627376-d414-4b33-a8c5-756cf5d231a1', '69de06e799b84be0d995a6321669bed741a945050d952838756c45a034ba5419', '2026-11-21 13:09:24.773', '2026-10-22 16:31:48.298', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 13:09:24.773'),
('2498356d-1536-4c07-945d-752022f725c7', '59627376-d414-4b33-a8c5-756cf5d231a1', 'e14a325d458f06059e976d04bc4ba44f340303f8c15b36db204455f51ee2323a', '2026-11-21 16:52:13.613', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 16:52:13.613'),
('2603f976-e074-426f-889a-7bd607067838', '59627376-d414-4b33-a8c5-756cf5d231a1', 'dbd4ba8c5ed41e3d30a1b41a306fe9c58db36e1990265dfea7f924559409275b', '2026-11-21 08:54:10.863', '2026-10-22 09:09:36.347', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 08:54:10.863'),
('2a738e7e-89fb-49c8-b600-eb9d73e920aa', '59627376-d414-4b33-a8c5-756cf5d231a1', '678e09a037266fbe9620e39d5cf41907afb042fac0527a82286f2b9e671349c3', '2026-11-29 11:11:31.220', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 11:11:31.220'),
('2a891e33-9847-4270-8ffd-fed9fccb27e8', '59627376-d414-4b33-a8c5-756cf5d231a1', 'fef932f8de5e870061e83895d3d31db81f9d9c74e52ebcc129e679feb7631676', '2026-11-21 09:43:24.623', '2026-10-22 10:03:15.599', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 09:43:24.623'),
('2dd12f35-0565-4007-acbf-5728f8d4b53e', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '8ff55822718e99326c681c4a4cd49fe12986a4224d64b66e5974ab125e804e7b', '2026-11-23 15:18:57.966', NULL, NULL, 'node', '::ffff:127.0.0.1', '2026-10-24 15:18:57.966'),
('2ec4f441-21f8-4f85-b02e-0a68b6cf0646', '59627376-d414-4b33-a8c5-756cf5d231a1', '7bde80d21e8aeafc1376606d90f208bdc0f6376c74db5f7c1676c670059f89ed', '2026-11-28 14:01:35.425', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-29 14:01:35.425'),
('30af7a67-dc9d-4909-adec-e01049d0cca1', '59627376-d414-4b33-a8c5-756cf5d231a1', '8c0b7cec00f9fe945bc3433f0ca0c5821c3cff44d24d44bf4f32b21f98712177', '2026-11-28 11:03:26.555', '2026-10-29 11:31:30.670', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-29 11:03:26.555'),
('30bae793-e738-471f-a690-53c34f522379', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '0017cf6faf6fec8c00eefdacbf06b71f7a498b286c4630122c38440d1d32b422', '2026-11-30 16:45:36.165', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-31 16:45:36.165'),
('31fbef05-22d2-40f0-a903-4ea9ddbe580e', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'f436e8e31a0bb5d20a20dd4f05fd433ecff8ab076062e275df5d097db1c648ac', '2026-11-23 15:03:06.242', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-24 15:03:06.242'),
('32f994ac-ec24-4462-9ff2-f229babad818', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '6da684278a08b060cee3d2da51b9eea5d53f0a9eeccfa0ef033c3f46780d5c3c', '2026-11-30 16:44:07.549', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-31 16:44:07.549'),
('342e2e36-cfe4-463b-9724-ceaa6f2bb9e7', '59627376-d414-4b33-a8c5-756cf5d231a1', 'a278054c284bcac64cf2d1080920a05f9da83d8fa997bba6782a33bee75b742e', '2026-11-29 16:22:47.874', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 16:22:47.874'),
('37b486ef-77c3-4f31-b146-306cf4ffec49', '59627376-d414-4b33-a8c5-756cf5d231a1', '290a438c57c9f483e1acd4a1f9e1ca458056e1b45c4388bb47ff8221d6b3fb1f', '2026-11-23 15:43:38.625', '2026-10-24 15:59:08.714', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 15:43:38.625'),
('38bc7dbc-281a-45eb-9fa6-e07f1b1d8295', '59627376-d414-4b33-a8c5-756cf5d231a1', 'b3c0efe73dd2a4fc1bdcdbc5b7092cf05040ba319a7c183583fe8e02446b920e', '2026-11-24 16:41:03.491', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-25 16:41:03.491'),
('39027c2f-6b78-4254-8d68-7b6d7c00dcea', '59627376-d414-4b33-a8c5-756cf5d231a1', 'b1c6f7c064f1694b37aed65c50c1f46ebf507d76eb699f0b0ec2ceb994ca6c91', '2026-11-29 10:56:17.539', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 10:56:17.539'),
('3aa49fcf-a17c-4e53-b52e-dc6d014843a2', '78f88de2-49db-4994-9db3-4e190abefe46', '04cebc6d296b2022929d30e5c80a27cae75022c4a71cc8dd45936818f72dd2be', '2026-11-21 08:52:46.147', '2026-10-22 08:53:55.039', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 08:52:46.147'),
('3c1c3639-810e-4802-8151-cd0d176897fd', '59627376-d414-4b33-a8c5-756cf5d231a1', '1d239b178c16d40a9086fc0d7695a4f923057619444b2814fb8e9b61092c9bc0', '2026-11-23 15:43:38.622', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 15:43:38.622'),
('3e909e05-ff96-4361-aca2-14cbc9e1fef4', '59627376-d414-4b33-a8c5-756cf5d231a1', 'cb21e38f6ae74237857924670e99af6336ac1a5ac4cda44bdb9307f2baef9157', '2026-11-28 12:09:46.515', '2026-10-29 14:01:35.402', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-29 12:09:46.515'),
('3ec79988-1e7a-4937-8bbb-d67909d7223e', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '04004cc0609bb97ff8e8818bafc250ef51dfb70b756f4655eef6f40e62b2db1d', '2026-11-23 14:41:56.437', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-24 14:41:56.437'),
('4106299a-fdd7-438e-9890-29f6c70f4024', '59627376-d414-4b33-a8c5-756cf5d231a1', 'cbd78299b761618f781dfebd7421bbfb81f947becae71eb219e72a77564abbc7', '2026-11-29 13:58:54.377', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 13:58:54.377'),
('417cec86-3801-4898-b628-9dba70bee114', '59627376-d414-4b33-a8c5-756cf5d231a1', 'ec19b1462d078978e4fabdb071fce2349d4289abfa7498d1f78faf1856ed6ba0', '2026-11-21 06:14:57.850', '2026-10-22 06:30:05.910', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 06:14:57.850'),
('45118aaf-10d6-4d55-8d68-3e07670fe113', '59627376-d414-4b33-a8c5-756cf5d231a1', '75367df66e46246b46cce8b60359d7bc9a8ec2b9dc96dfcc5bb4e4f4579a43cf', '2026-11-29 16:06:59.944', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 16:06:59.944'),
('45b81806-b247-415f-8ad6-f358e15380fe', '59627376-d414-4b33-a8c5-756cf5d231a1', '57203cede827799a0cca8a15ef7801e347cfeaed11a9a73ac5345f3a24e6487a', '2026-11-23 14:33:54.272', '2026-10-24 14:49:17.609', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 14:33:54.272'),
('475b3a5b-8918-434f-af04-f3ab406cb9ee', '59627376-d414-4b33-a8c5-756cf5d231a1', 'fbad2c43c02006114381127fd7a10fe2c70d6ca1b1459b934500d65c5646cae0', '2026-11-28 14:41:33.297', '2026-10-30 10:56:16.673', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-29 14:41:33.297'),
('47ac93ab-ed41-4b90-a6dd-262d28139a84', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '0ef21981012ff8c0cd3d7ff6acd9a14b826a1e273e2caebe01037e2c50a1cecf', '2026-11-19 10:18:41.538', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::ffff:127.0.0.1', '2026-10-20 10:18:41.538'),
('48448135-340f-48c6-a07f-4a951b00ac01', '59627376-d414-4b33-a8c5-756cf5d231a1', 'f6b2eae2462350778bdef4a214813ba8b83eca2dffb2e78295cd8f2856bfd69e', '2026-11-23 16:25:37.060', '2026-10-25 14:27:20.414', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 16:25:37.060'),
('4abd8a27-f24a-4c14-a778-abf1e4c90e49', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '20b39daaf89892fb4e679062ccbfa17fc30890d7ca8bbc6cd6368cecd520ead6', '2026-11-23 15:22:26.990', NULL, NULL, 'node', '::ffff:127.0.0.1', '2026-10-24 15:22:26.990'),
('4af4ed7c-1d44-4821-a941-213b686dda46', '59627376-d414-4b33-a8c5-756cf5d231a1', 'de94869b2afe07a183edb3869c532a69803276570d4aefe4bb0a14f780f825ee', '2026-11-21 06:30:05.943', '2026-10-22 08:14:22.725', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 06:30:05.943'),
('4b2559d8-b843-405f-b67b-371be1900b32', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'ba98175a7a647b07c9e0cbc1dc700f3b2efad136c8c4f7c62f68602bcf10e4fe', '2026-11-23 14:55:32.204', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-24 14:55:32.204'),
('4bb730c9-2168-416d-aec2-3bcdc5b1a1ae', '59627376-d414-4b33-a8c5-756cf5d231a1', '856c701b77c83ac9d81118af74a4ea0457410fc2ee9a649e5497bf4addd752ad', '2026-11-23 15:59:08.731', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 15:59:08.731'),
('4c63e5a2-dc0e-4628-b20f-3bde4f87e173', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '04489034063ed729404ee965bcbc45bafa1f65667fb6ed009e1c13b359347b5e', '2026-11-21 10:41:06.897', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-22 10:41:06.897'),
('4e0827dc-ba1b-4697-80e2-ebcbba918782', '59627376-d414-4b33-a8c5-756cf5d231a1', 'a216a3027935e4bf39093f8340e37effc08d4f51d8d17c58439bc2a6263816bf', '2026-11-29 16:22:47.874', '2026-10-31 15:44:17.265', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 16:22:47.874'),
('4f5a12d0-90fb-4124-bff9-7764b14ee695', '59627376-d414-4b33-a8c5-756cf5d231a1', '3cfcd5bcd69c2f6ebfd2c30a620e85d7492439c33264a2fcdee8a374556aabdc', '2026-11-29 11:36:45.250', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 11:36:45.250'),
('4f800352-a93a-4662-be0a-82031490583c', '59627376-d414-4b33-a8c5-756cf5d231a1', '997608cff9d42aef685cdeefd79d8dab984986ac721538a3396dcbf31fc52e58', '2026-11-23 16:25:37.039', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 16:25:37.039'),
('50bea1f6-6050-41c0-b124-c2056a0eaf36', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '351c80ddb1c37d6b29decb605738a5967e40895f08e67a3dea9db60b4c9f173c', '2026-11-21 10:41:52.322', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-22 10:41:52.322'),
('532b948b-afe6-4b4e-ad1d-9ca8dc132eda', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'a0da7c8bdb2cb1dde7adbc4f7bd7ad8a2fe00c0eaed035e3948c2cf1be500287', '2026-11-21 11:39:43.374', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-22 11:39:43.374'),
('538c2f23-d2c0-4acb-9adc-5ed007f84760', '59627376-d414-4b33-a8c5-756cf5d231a1', 'cb94bb43dc38598fc1ac5abe8086781df1aefdbf9e0d60640fa663da3c9b0b24', '2026-11-23 15:59:08.732', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 15:59:08.732'),
('543f4bba-3d20-4dad-93ec-a13adc7f478f', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'ca7552e337ddc3a442899b8a6e0fb9fb58b8a2f50850bfaace53567f91a25b26', '2026-11-30 16:46:05.502', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-31 16:46:05.502'),
('5a274705-48f0-4276-87cd-6172edd39038', '59627376-d414-4b33-a8c5-756cf5d231a1', 'b5793559b71230856e36fc8dc16d9276822d018ceba92a65fbf1dfe2f07bf904', '2026-11-21 09:09:36.359', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 09:09:36.359'),
('5a78aa6c-195c-4ed6-9eb0-14a6bb560558', '567797f6-c8d3-4ea0-b53a-19838a82f44a', '14697a6ab7ff97f8c2c7e6de57cc9d0235ba017dbab09c949497c9cc3ecce17f', '2026-11-19 12:02:51.993', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 12:02:51.993'),
('5b3eaf7f-ce14-46f3-b430-3ff3dc131b1d', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'f50f75c103dba6d9cce8bec9ecef3da71167373f6dae442ec974b9430a72c251', '2026-11-30 16:39:24.738', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-31 16:39:24.738'),
('5c13d344-14a4-4cf6-9687-0dc9fb139963', '59627376-d414-4b33-a8c5-756cf5d231a1', 'f57fdd42e59087b1a84ec7f81716ade4c062fbdf9456d92965ef1a20884d6444', '2026-11-26 10:30:04.603', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-27 10:30:04.603'),
('5f055027-a14a-4877-bcf2-96fa4b4d1032', '59627376-d414-4b33-a8c5-756cf5d231a1', '37f1b9cf151c88961cb818fbc8d2e68e69ae8b59a2b06671fae3bdcba92fab0f', '2026-11-19 09:58:00.709', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 09:58:00.709'),
('60952e55-9a85-42a1-92ab-fe4088e48459', '59627376-d414-4b33-a8c5-756cf5d231a1', '71f1a534a004d00b02d81622097da19e47c726c3bb10516714fd17385930c09c', '2026-11-29 11:53:22.358', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 11:53:22.358'),
('64634917-c0db-4286-af64-81ce99c575c3', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '81c8894e28b2551298250b8e8962c7fb7c8e1c23d8f3f2ad02f45311cad3aae0', '2026-11-19 10:18:52.910', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::ffff:127.0.0.1', '2026-10-20 10:18:52.910'),
('65083da0-8241-4a9e-b42d-dbbfd8dea014', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'edd2b2393213d69260eec24be72feeeac27318329992945c18acceb031f0201b', '2026-11-23 15:13:49.057', NULL, NULL, 'node', '::ffff:127.0.0.1', '2026-10-24 15:13:49.057'),
('6582b034-57b3-4615-a165-eea02236a2f7', '59627376-d414-4b33-a8c5-756cf5d231a1', 'aac65b81cc00f7797c008c4f635f11d2faab50b9a4f4b34b68aa5c44f1d185c0', '2026-11-29 10:56:17.594', '2026-10-30 11:11:31.208', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 10:56:17.594'),
('686c958b-564b-4f39-9dd6-3c997cf8954e', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'f994ec252802b45b3d9581c73b32026a24129d0119b422ae13b955be7c2a3161', '2026-11-21 05:59:22.112', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::ffff:127.0.0.1', '2026-10-22 05:59:22.112'),
('68abff51-8665-4a40-866f-9909ef3555c3', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '416356a72da3291bda5e1e7cd03caad4742bfcc2b0d2a4347838fb0e72f0028b', '2026-11-21 11:15:05.877', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-22 11:15:05.877'),
('6950b427-65ca-419e-a4c3-b220b6f585f3', '59627376-d414-4b33-a8c5-756cf5d231a1', '4e34df9e62c16604fcd0dfd5acf1a446124410217f0024b9aebfb190326ca923', '2026-11-21 17:09:36.414', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 17:09:36.414'),
('6b1786eb-1d7d-483f-a071-9a1f46e187d5', '59627376-d414-4b33-a8c5-756cf5d231a1', '4b2757990243f78867f0c34481efb8c1e76219d76d65dc6d339b77988c65ebf1', '2026-11-20 16:29:20.613', '2026-10-22 06:14:57.837', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-21 16:29:20.613'),
('6c00fa39-4484-4c93-ba68-b7314106564c', '59627376-d414-4b33-a8c5-756cf5d231a1', 'a92862f1d3077fd0386366533242fc5fe564cf1159ed5af29823bde9b6ffac4c', '2026-11-21 12:21:28.728', '2026-10-22 12:53:40.327', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 12:21:28.728'),
('6dd46408-89d1-442f-bc31-b28487b21a42', '59627376-d414-4b33-a8c5-756cf5d231a1', 'aa0d0483491a418f48efc19d4d265da82506f745e70be3dd015814670d13a723', '2026-11-19 11:52:01.855', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 11:52:01.855'),
('7010580f-0c5e-4ba8-966d-b271fc0f58b2', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '9186857d7958189bdd5c64affa0d4932cbb33734553cc19586c85ae637faafe9', '2026-11-30 16:44:15.486', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-31 16:44:15.486'),
('716a54e6-7c78-4243-847f-ea664cb46a3b', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'a947c373e3df04384b578834f8eb221feb2f642822eaa302ead90311004ec500', '2026-11-19 10:13:20.453', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::ffff:127.0.0.1', '2026-10-20 10:13:20.453'),
('75410e74-7cdc-4f70-bbba-0792e7442013', '59627376-d414-4b33-a8c5-756cf5d231a1', '0e6d5560bee9a356daf8887f71af158dc78b331c73d9ae086a8b435be355afb2', '2026-11-21 08:14:22.792', '2026-10-22 08:48:23.360', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 08:14:22.792'),
('764c02ad-ce9f-4a0d-bc06-9db1f4d76a3a', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '5bfd5700b5344067c97f62345f9ef81f0b660bdbfc089f13a6badf9fc646b6a8', '2026-11-21 10:41:28.334', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-22 10:41:28.334'),
('7819e219-8564-48b8-9d31-4aac0b6f5826', '59627376-d414-4b33-a8c5-756cf5d231a1', '2a19f6cdcc3886cedfab7e4100b079fc728b5434194518386def91fd40fcf40f', '2026-11-21 10:25:18.656', '2026-10-22 11:11:18.706', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 10:25:18.656'),
('78c01284-0800-4747-914c-35d66ccd9058', '59627376-d414-4b33-a8c5-756cf5d231a1', 'c1fe4560a4d7c678eb3e311dab1fd8b43e70f79923d95e25fe81b75405d7ab11', '2026-11-19 10:18:50.180', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 10:18:50.180'),
('7af5341f-ca8d-49dc-974f-e0b63fefe5fc', '59627376-d414-4b33-a8c5-756cf5d231a1', '780ff98337e0068f2c92908488c967e298877025266e316b4464a41c7b5ec794', '2026-11-29 11:11:31.222', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 11:11:31.222'),
('7af8e5c7-e319-43b5-90dc-5036b4302d0d', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '40a85a730ebf3e47e3d5384d858c2f91a88aef60768ffdd906244b7aeb046e9a', '2026-11-23 15:17:35.689', NULL, NULL, 'node', '::ffff:127.0.0.1', '2026-10-24 15:17:35.689'),
('7b9b016c-481b-408e-b5fb-3c4df479294a', '59627376-d414-4b33-a8c5-756cf5d231a1', '3aea6c2dcae13e90e43d561feb80cdb0050dfe6a2e4d0e5a7a6fe16d85be67b5', '2026-11-19 10:16:45.481', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 10:16:45.481'),
('7ba508e4-930a-474c-b12d-d697d03c9f9a', '59627376-d414-4b33-a8c5-756cf5d231a1', 'ffbb7049ef9230e87d805943c86d8281ac5d322cdd90efebb24b1b1183d6c2b2', '2026-11-26 10:41:41.238', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-27 10:41:41.238'),
('7c9b38ee-976b-4a97-81ad-b0f8e5db689d', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '0db95b46966bddcab72377cfd8d4b8a6f778b644d7697e04273e7d0d825d9b36', '2026-11-23 15:22:35.723', NULL, NULL, 'node', '::ffff:127.0.0.1', '2026-10-24 15:22:35.723'),
('7f170575-108d-4352-9857-93b3a1addd0b', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'd8982c0c9d6b1654f1f6a611842d421280b51892522bb43a5a04b3cde169c566', '2026-11-30 16:43:06.115', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-31 16:43:06.115'),
('81890bb7-02be-4f5d-af65-691392a6f33d', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '71380d9116451b7cab9e392452148e48b98171cd0dfc64f91dd6005192fed8d1', '2026-11-21 05:59:13.508', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::ffff:127.0.0.1', '2026-10-22 05:59:13.508'),
('820fe396-a7ed-4cae-9038-8250e1dad71e', '59627376-d414-4b33-a8c5-756cf5d231a1', '411fb1df582d79c6443f2541f047298b2025dee27ae082e0b683161f256a3928', '2026-11-24 16:41:03.494', '2026-10-27 10:24:28.010', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-25 16:41:03.494'),
('82f168db-cba0-45a0-97a0-82e0f9600d59', '59627376-d414-4b33-a8c5-756cf5d231a1', '9cbf038d446468db382e3659dfa4c799e6b1666767338e4b139c112ef970bf6d', '2026-11-19 10:16:45.482', '2026-10-20 10:17:45.448', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 10:16:45.482'),
('8447f8e5-4992-4976-98f9-c1c6a31d3cd9', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '3da9e4c4898b3b71ec74fe7b54580893ab661efe2bb8128ede9a927fec663a16', '2026-11-21 05:58:54.307', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::ffff:127.0.0.1', '2026-10-22 05:58:54.307'),
('874e0c7a-b3ab-4196-bb71-1c9ac0dccb58', '59627376-d414-4b33-a8c5-756cf5d231a1', '6e933abd314a1f0d476d69e5e70b6dbf41897926b45a3d3fad34d238efd101e8', '2026-11-21 11:11:18.723', '2026-10-22 12:03:26.101', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 11:11:18.723'),
('87519af4-351b-4ee9-b6f8-d93b765d3329', '59627376-d414-4b33-a8c5-756cf5d231a1', 'a18b389b51e72ade569d3df3ceee0f34f617ee2c6a6a431926326254e6b73d46', '2026-11-29 15:23:05.446', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 15:23:05.446'),
('8787a03e-65fc-4df2-81b4-e470c83c780f', '59627376-d414-4b33-a8c5-756cf5d231a1', '0458f3b21ed5781d2bf3f4f33a686fc15996666fd845ad6b9a8522905bbbdc49', '2026-11-29 11:20:10.525', '2026-10-30 11:36:45.211', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 11:20:10.525'),
('8a535157-8801-4459-a13f-9f5ba4a441a1', '59627376-d414-4b33-a8c5-756cf5d231a1', 'f6a8719119351dd74ebe85b76e06cc6d4e6256418ebf7b6d9500972a8c4aaa85', '2026-11-19 10:35:54.896', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 10:35:54.896'),
('8b2dff30-bf84-4033-b907-3a5c92a8cfda', '59627376-d414-4b33-a8c5-756cf5d231a1', '034b9755c38cf92ee4ddce7af3f75fe97958bb17fd44227d9a454e8316d4925c', '2026-11-19 10:35:54.896', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 10:35:54.896'),
('8bf111ba-3dc9-48ae-9a99-5b9ea882a7b1', '59627376-d414-4b33-a8c5-756cf5d231a1', '3bbe6d223f847fb4ee7e0275a0cd5020d3091f30d4dbd6ab1a5dc8d92c500aa9', '2026-11-26 10:24:28.029', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-27 10:24:28.029'),
('944edde8-6b92-46b7-83b2-0d1e3a4a6225', '59627376-d414-4b33-a8c5-756cf5d231a1', 'bf14e6b19ad8927d6ecd462f58199b7382863b50d367f5558a6847ecc4b26f28', '2026-11-28 14:01:35.421', '2026-10-29 14:25:57.092', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-29 14:01:35.421'),
('96315634-cc52-40d9-9021-f494c79ae719', '59627376-d414-4b33-a8c5-756cf5d231a1', '80dde8a8cc3bb00c435d8644eb499e5b28ed7826ab504274c63ec66af1dbb4c5', '2026-11-29 15:23:05.446', '2026-10-30 15:51:48.075', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 15:23:05.446'),
('9874aa6e-5f0e-4204-9caa-722708455e1d', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '9cb23fd004c3df34759fd131f996a8f7bcc70982ac7eb89accdcbb20920c4981', '2026-11-19 10:12:57.131', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::ffff:127.0.0.1', '2026-10-20 10:12:57.131'),
('9be49505-f3e5-471f-a9af-8a9b2a43243a', '59627376-d414-4b33-a8c5-756cf5d231a1', '799a44f046c403a19b955e274f7acfaa87ca2218e7d1aafd565ca7b27e943ec9', '2026-11-23 15:59:08.731', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 15:59:08.731'),
('9f12e8e2-e0ef-43c7-b285-9a8209153f66', '59627376-d414-4b33-a8c5-756cf5d231a1', 'f38d150221041ab5faa8725969698424593f8960eb33f4d541384517c7f83f83', '2026-11-28 14:25:57.434', '2026-10-29 14:41:33.290', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-29 14:25:57.434'),
('a21de48d-202e-4f09-a7a5-2d4c9773236a', '59627376-d414-4b33-a8c5-756cf5d231a1', 'b11fc0dcaa1ec83784a06004d33f9f0458ef33c068d4375c99889f120b9d045b', '2026-11-19 16:22:05.805', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 16:22:05.805'),
('a2729e69-2aec-4ea2-a589-dd655fbd7c1e', '59627376-d414-4b33-a8c5-756cf5d231a1', 'a56dc8cf150499d8e5d39abcd73961c757dbf5a059fa118e0d1ffdd91efbd0c1', '2026-11-29 16:06:59.944', '2026-10-30 16:22:47.865', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 16:06:59.944'),
('a798e94d-95e7-4dae-9636-cb66f0e9fd7e', '59627376-d414-4b33-a8c5-756cf5d231a1', '3a09c20b7386c03b68d6449af2c27a933624d8a1d50d9ee7285dd0ca4baced68', '2026-11-28 11:02:05.383', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-29 11:02:05.383'),
('ac7df86c-ecbc-486e-916d-775c4793d05a', '59627376-d414-4b33-a8c5-756cf5d231a1', '7fb3077b6d40291d9c6e6935dc16fe34cfd6a58667f32aa2386061d055935998', '2026-11-21 16:31:48.339', '2026-10-22 16:52:13.594', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 16:31:48.339'),
('adee4e22-b26c-4b04-a59c-be6fefa55c07', '59627376-d414-4b33-a8c5-756cf5d231a1', 'e3487b052ef762eeea179c9a7a1399a4d684cedf87b016e348d8b5a385eda744', '2026-11-29 14:14:25.738', '2026-10-30 14:51:04.216', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 14:14:25.738'),
('aef39a27-dd9d-49bc-97b2-043d630e02a5', '59627376-d414-4b33-a8c5-756cf5d231a1', '612c6b1a39987c6d91b83b1b1027e303e06a613c9fbca469c78d449a1d7ae98f', '2026-11-28 11:31:30.690', '2026-10-29 11:50:17.784', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-29 11:31:30.690'),
('afadfb9d-0371-44e9-b3bb-e300b0e04d5a', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '5900b38096ce6dc96e801e796089e18acfac4c4da18611bd6fc4bca574eeb3c4', '2026-11-30 16:42:34.934', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-31 16:42:34.934'),
('b3753fad-2701-4e85-bb83-37db4e4de55f', '59627376-d414-4b33-a8c5-756cf5d231a1', '7aebd7f76a61ccb19fa31a66136fd6129faf361d31a4baf8c2191b8d527f7809', '2026-11-23 15:25:27.721', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 15:25:27.721'),
('b3ea9eb1-fd33-426f-8882-8f6614667ef1', '59627376-d414-4b33-a8c5-756cf5d231a1', '324deccfb4cc0220d0e33fcad6bfcd80ca62cc0110795626cfd5b6110aac3214', '2026-11-23 14:49:17.621', '2026-10-24 15:08:38.179', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 14:49:17.621'),
('b4948f72-a0e9-488c-8bc4-c47416df0d5c', '59627376-d414-4b33-a8c5-756cf5d231a1', 'c5d6d55a212e7bb5d765cb92004a81c0b67668d7b7d71bc2092fe6d2edc7ef47', '2026-11-23 15:59:08.731', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 15:59:08.731'),
('b51e0558-cd6a-4028-977a-9a2f64d43e48', '59627376-d414-4b33-a8c5-756cf5d231a1', '52e8757b004aeb6b8daeb51102cb1f5af2a907abb6acfe96587e2b6034a349bf', '2026-11-28 14:41:33.297', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-29 14:41:33.297'),
('b5b79ec8-58b6-4912-be56-b230938cdf3f', '59627376-d414-4b33-a8c5-756cf5d231a1', 'a557a86c93ee637943bc4c04e7b0058205dd11832ffb3142c679323038438749', '2026-11-19 09:40:07.506', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 09:40:07.506'),
('b7987c95-d2ba-43f1-a76b-620dbfd0c9d4', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '3443d7382608f24ff6532c985798fa7e530e4c38bb686d510c7bb4f23dc61bf6', '2026-11-23 14:55:56.595', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-24 14:55:56.595'),
('b83bc4f1-9e53-4be0-abe0-24c95ee835ce', '59627376-d414-4b33-a8c5-756cf5d231a1', 'e5eef5613970045d2364d278635c1ffb649b58d84339855086640fcf0518b8bf', '2026-11-29 11:53:22.363', '2026-10-30 13:58:54.350', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 11:53:22.363'),
('b9ed47c2-c1aa-46d3-ae8d-e7bba72ef57e', '59627376-d414-4b33-a8c5-756cf5d231a1', 'bce33b957ab13d79f1dfe807d7679d6a9f2ef382cc83b12aa82c54b63114d239', '2026-11-24 14:27:20.433', '2026-10-25 16:41:03.475', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-25 14:27:20.433'),
('be6c1f3c-681d-4e5f-9b3a-ae926eb8bfba', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '0a69b137435fe14898a1ba5c5c4c4ac74e77756e0bb1fcf09c07c45e0687f49f', '2026-11-21 10:41:36.720', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-22 10:41:36.720'),
('bff39eab-8afa-4f94-9088-b08d6ce6bd91', '59627376-d414-4b33-a8c5-756cf5d231a1', 'd0e5687f239bfe68360f0daddffb579d2282115c932f76591e0a9b2e3110d864', '2026-11-21 16:52:13.613', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 16:52:13.613'),
('c16ae813-a00c-4795-8427-7499b3f0b010', '59627376-d414-4b33-a8c5-756cf5d231a1', 'dd411450c096d7cfc0842e3635afe69a12fe7e6042ec922e7a94c5830fcc48e0', '2026-11-19 09:40:18.819', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 09:40:18.819'),
('c2db34f6-ee83-4c9a-901b-3eda7d921791', '59627376-d414-4b33-a8c5-756cf5d231a1', 'd46439c406d740befaf6d31e490db88b0a2a3d32928e88de119ca928f5246ec1', '2026-11-19 11:52:01.856', '2026-10-20 12:02:31.917', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 11:52:01.856'),
('c436766f-8f61-4568-8eb1-4b9aca940581', '59627376-d414-4b33-a8c5-756cf5d231a1', 'cc086e511da84079b2481da2a24ffd904ea38aa6bc39f3f3b03d478572812d2d', '2026-11-29 15:51:48.092', '2026-10-30 16:06:59.933', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 15:51:48.092'),
('c604df47-5359-4a53-9907-307bd863e7f1', '59627376-d414-4b33-a8c5-756cf5d231a1', '27a0c761b5569d2d02121d219fa737e68f7d2a7a210c178e239ee43d0d1dfb97', '2026-11-21 12:03:26.123', '2026-10-22 12:21:28.714', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 12:03:26.123'),
('c821cc8b-db13-4434-b955-f724b4da8ba1', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'b8b75c81e2eccc9242d6dfd823835f5ab14184bff4a8acfad72062b6bc3afe7e', '2026-11-21 11:15:20.513', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-22 11:15:20.513'),
('ccd59401-3645-4d0c-a7bc-c4afb075411c', '59627376-d414-4b33-a8c5-756cf5d231a1', 'c67a138e21628384eb0ee376c95f832ad800d07b9e9850df6c57c2c319c1faa8', '2026-11-21 12:21:28.726', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 12:21:28.726'),
('cd40d814-bb77-40f8-b98d-9d5036c4a11a', '59627376-d414-4b33-a8c5-756cf5d231a1', 'bd81dfda85fa98501c43842d582aef152f427fc15e26b06c55a99a4a39e1023c', '2026-11-23 16:25:37.039', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 16:25:37.039'),
('ce1abe3a-0091-4746-9379-9b97c4e88cee', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '520b36700de61000ee771b249c4ac7a8ae03ae028a74abff76e34dfbfe2fafbc', '2026-11-21 11:22:39.772', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-22 11:22:39.772'),
('d0668df9-910d-40e7-a78d-ecdb55c996f8', '59627376-d414-4b33-a8c5-756cf5d231a1', 'ecf07492a77907992da206ada785b177d94ec799eac1492eac977d464c147d02', '2026-11-30 17:58:00.368', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-31 17:58:00.368'),
('d432972a-28a0-4f4c-9d3e-c44d70f1f833', '59627376-d414-4b33-a8c5-756cf5d231a1', '912bf46e95fa1c949798a14ce8483596b1d574434aa876fb45aebc3a547d94cd', '2026-11-19 11:31:30.251', '2026-10-20 11:52:01.842', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 11:31:30.251'),
('d47d0893-cb91-4b5d-bcef-5dc4540c9041', '59627376-d414-4b33-a8c5-756cf5d231a1', '0cf7d650db6474bd06a28fb971d2c88aedbff776cdd5d3bedb457c6c47fbcaee', '2026-11-29 14:14:25.737', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 14:14:25.737'),
('d66b76e8-32a6-4e34-89f3-18fb41c41338', '59627376-d414-4b33-a8c5-756cf5d231a1', 'db9db863d107fa1db3912d1ba25e9ced48672f7a08ebcebe4f096c21536f15da', '2026-11-19 10:18:59.603', '2026-10-20 10:35:54.888', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 10:18:59.603'),
('da2c0240-460d-4de8-a982-67f6ba68a7f2', '59627376-d414-4b33-a8c5-756cf5d231a1', '89485c49b47c5811f84aa0cb6a19eceeb473a85446b33a032814e97541fea747', '2026-11-28 14:25:57.398', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-29 14:25:57.398'),
('daf4e67f-64e2-43a6-9fcf-36dc10728335', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '04c0cfa263f9028b5527eef3373cda87834b296e62fc080384eb5a2c4ee5b153', '2026-11-19 10:18:28.664', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::ffff:127.0.0.1', '2026-10-20 10:18:28.664'),
('dce70a47-998c-4db5-b93b-6e180adffaf9', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'e70f21e171bfedf454d65be462bb6c005122b081ba2a7bb91dc821aee77da2c2', '2026-11-19 10:13:07.108', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::ffff:127.0.0.1', '2026-10-20 10:13:07.108'),
('df054bf5-c27b-4e15-ba67-37eb54adef61', '59627376-d414-4b33-a8c5-756cf5d231a1', '32728d6f50bdd733d2025241d1ec31fe80f233d73f3ba4169ad1a23c6d25ec16', '2026-11-21 16:52:13.625', '2026-10-22 17:09:36.393', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 16:52:13.625'),
('e39042b2-e12f-4024-9816-3d0f69590300', '59627376-d414-4b33-a8c5-756cf5d231a1', 'bb41a850a5dee9f7c05b6bc3ef5b3e53b042936274152ca20d71e7644a33dfcf', '2026-11-24 14:27:20.433', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-25 14:27:20.433'),
('e4d6afde-ad17-4850-a44e-4b29a3d5babe', '59627376-d414-4b33-a8c5-756cf5d231a1', '90e16431c458f6facfdf91389383b9ab93da03c1bbf9264720d3a12140628930', '2026-11-23 15:08:38.221', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 15:08:38.221'),
('e501b607-69e1-4e1e-9733-07a263964aeb', '59627376-d414-4b33-a8c5-756cf5d231a1', '52a45bd657e2d0946db2a431876a43080514919260c4c9629a884a5a3f043b9f', '2026-11-21 08:48:23.386', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 08:48:23.386'),
('ed10598e-7ca7-4970-aa49-1b7b6526064c', '59627376-d414-4b33-a8c5-756cf5d231a1', '6383e83341047bdd5cac6d574b6073ff304ba51bea4c96bbacea1af46a472215', '2026-11-21 16:31:48.340', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 16:31:48.340'),
('ed866418-705a-484b-b517-81eafdab1b22', '59627376-d414-4b33-a8c5-756cf5d231a1', 'edf667e68557fc5e3612a5ff8257d0ff548a83194fc7d0497dee6b4c17c2ea82', '2026-11-29 14:51:04.226', '2026-10-30 15:23:05.437', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 14:51:04.226'),
('ede7921b-89ec-4278-b29f-fbf4a7d4455f', '59627376-d414-4b33-a8c5-756cf5d231a1', 'f912e84a0efc9beb5f827226511801294026c8f12830ddc83dd4da99649dc4c8', '2026-11-21 09:28:14.890', '2026-10-22 09:43:24.608', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 09:28:14.890'),
('ef8d81de-6436-44f8-a27d-f14fde191850', '59627376-d414-4b33-a8c5-756cf5d231a1', 'dd5830a7948168c9b9339f4b9132d7410776e4123001237fb57e36109c7fd11e', '2026-11-29 15:51:48.091', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-30 15:51:48.091'),
('f137507d-314b-4265-98db-d9456e6907d5', '59627376-d414-4b33-a8c5-756cf5d231a1', 'e6dd4924ef3b53f0295fe848af527b16e1f8a6fc6ca86567128dd30018609d9e', '2026-11-21 10:03:15.619', '2026-10-22 10:25:18.631', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-22 10:03:15.619'),
('f7df4f65-cc0d-479f-9f64-c4ad42c4b97c', '59627376-d414-4b33-a8c5-756cf5d231a1', '65868f2b868fe18ae3d3dac7c389054f18cf5638a55281172e275a9218716ddd', '2026-11-28 11:50:17.793', '2026-10-29 12:09:46.492', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-29 11:50:17.793'),
('f9e56a6d-95d4-4e39-8298-9bb08d3a4ac8', '59627376-d414-4b33-a8c5-756cf5d231a1', 'e64e243a599f297e2f7b73bd78e01db7ff13499aae23e9ad8d601797953a3d84', '2026-11-19 10:00:31.282', '2026-10-20 10:16:45.477', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 10:00:31.282'),
('fa36cdf6-a457-417a-a4c4-a601fa9b900b', '59627376-d414-4b33-a8c5-756cf5d231a1', '24934e5c26246c1775796cd2f17d3b1311a2f7d30ee5c27b2584ae99950377a8', '2026-11-23 15:59:08.731', NULL, NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 15:59:08.731'),
('fb1a2a2d-71bd-4f6c-bb01-950952541c0e', '59627376-d414-4b33-a8c5-756cf5d231a1', '95105b842f85bbc17984a53199d7a22131a01ba739fe406badd3ae7f954e99c2', '2026-11-23 15:25:14.427', '2026-10-24 15:25:27.718', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-24 15:25:14.427'),
('fda0af52-3c05-491c-a4d5-3b120de48ad1', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '8b344fbf6005a5794add558f583458a4dda58bca39001b62ddd64c7488ec2e8b', '2026-11-26 10:38:39.963', NULL, NULL, 'node', '::ffff:127.0.0.1', '2026-10-27 10:38:39.963');
INSERT INTO `refresh_sessions` (`id`, `user_id`, `token_hash`, `expires_at`, `revoked_at`, `rotated_from`, `user_agent`, `ip`, `created_at`) VALUES
('fe895df4-7bc9-4bf7-b5b4-453aba80120f', '83a96de8-003d-438e-8cb8-b79e6abadbd1', '9f9b3dd55f3b30a89de0ce49e133a97eac2d0365c0da231d9bb9110e1f246c85', '2026-11-23 15:03:30.955', NULL, NULL, 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::1', '2026-10-24 15:03:30.955'),
('ff883ea4-9ad1-4d2d-8868-06c5679a1494', '59627376-d414-4b33-a8c5-756cf5d231a1', '4e2f74e2b257cd048dc94808cbd826c0f890694d87b1dbf09a63911c2bc19eff', '2026-11-30 16:42:06.837', '2026-10-31 17:58:00.334', NULL, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-31 16:42:06.837'),
('rs-1', 'user-1', 'refresh-token-1', '2026-11-28 14:33:00.303', NULL, NULL, NULL, NULL, '2026-10-29 14:33:00.303'),
('rs-2', 'user-2', 'refresh-token-2', '2026-11-28 14:33:00.303', NULL, NULL, NULL, NULL, '2026-10-29 14:33:00.303');

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

CREATE TABLE `role_permissions` (
  `role` enum('owner','admin','manager','agent','analyst','viewer') NOT NULL,
  `permission` varchar(96) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_permissions`
--

INSERT INTO `role_permissions` (`role`, `permission`) VALUES
('owner', 'agents.publish'),
('owner', 'agents.read'),
('owner', 'agents.write'),
('owner', 'analytics.read'),
('owner', 'audit.read'),
('owner', 'billing.read'),
('owner', 'bookings.read'),
('owner', 'bookings.write'),
('owner', 'campaigns.read'),
('owner', 'campaigns.send'),
('owner', 'campaigns.write'),
('owner', 'channels.read'),
('owner', 'channels.write'),
('owner', 'contacts.read'),
('owner', 'contacts.write'),
('owner', 'conversations.assign'),
('owner', 'conversations.read'),
('owner', 'conversations.write'),
('owner', 'flows.publish'),
('owner', 'flows.read'),
('owner', 'flows.write'),
('owner', 'knowledge.read'),
('owner', 'knowledge.write'),
('owner', 'leads.read'),
('owner', 'leads.write'),
('owner', 'members.manage'),
('owner', 'members.read'),
('owner', 'messages.send'),
('owner', 'orders.read'),
('owner', 'orders.write'),
('owner', 'settings.manage'),
('owner', 'templates.read'),
('owner', 'templates.write'),
('owner', 'tickets.read'),
('owner', 'tickets.write'),
('owner', 'webhooks.manage'),
('owner', 'workspace.read'),
('owner', 'workspace.update'),
('admin', 'agents.publish'),
('admin', 'agents.read'),
('admin', 'agents.write'),
('admin', 'analytics.read'),
('admin', 'audit.read'),
('admin', 'billing.read'),
('admin', 'bookings.read'),
('admin', 'bookings.write'),
('admin', 'campaigns.read'),
('admin', 'campaigns.send'),
('admin', 'campaigns.write'),
('admin', 'channels.read'),
('admin', 'channels.write'),
('admin', 'contacts.read'),
('admin', 'contacts.write'),
('admin', 'conversations.assign'),
('admin', 'conversations.read'),
('admin', 'conversations.write'),
('admin', 'flows.publish'),
('admin', 'flows.read'),
('admin', 'flows.write'),
('admin', 'knowledge.read'),
('admin', 'knowledge.write'),
('admin', 'leads.read'),
('admin', 'leads.write'),
('admin', 'members.manage'),
('admin', 'members.read'),
('admin', 'messages.send'),
('admin', 'orders.read'),
('admin', 'orders.write'),
('admin', 'settings.manage'),
('admin', 'templates.read'),
('admin', 'templates.write'),
('admin', 'tickets.read'),
('admin', 'tickets.write'),
('admin', 'webhooks.manage'),
('admin', 'workspace.read'),
('admin', 'workspace.update'),
('manager', 'agents.publish'),
('manager', 'agents.read'),
('manager', 'agents.write'),
('manager', 'analytics.read'),
('manager', 'audit.read'),
('manager', 'bookings.read'),
('manager', 'bookings.write'),
('manager', 'campaigns.read'),
('manager', 'campaigns.send'),
('manager', 'campaigns.write'),
('manager', 'channels.read'),
('manager', 'channels.write'),
('manager', 'contacts.read'),
('manager', 'contacts.write'),
('manager', 'conversations.assign'),
('manager', 'conversations.read'),
('manager', 'conversations.write'),
('manager', 'flows.publish'),
('manager', 'flows.read'),
('manager', 'flows.write'),
('manager', 'knowledge.read'),
('manager', 'knowledge.write'),
('manager', 'leads.read'),
('manager', 'leads.write'),
('manager', 'members.read'),
('manager', 'messages.send'),
('manager', 'orders.read'),
('manager', 'orders.write'),
('manager', 'templates.read'),
('manager', 'templates.write'),
('manager', 'tickets.read'),
('manager', 'tickets.write'),
('manager', 'webhooks.manage'),
('manager', 'workspace.read'),
('agent', 'agents.read'),
('agent', 'bookings.read'),
('agent', 'bookings.write'),
('agent', 'campaigns.read'),
('agent', 'channels.read'),
('agent', 'contacts.read'),
('agent', 'contacts.write'),
('agent', 'conversations.assign'),
('agent', 'conversations.read'),
('agent', 'conversations.write'),
('agent', 'knowledge.read'),
('agent', 'leads.read'),
('agent', 'leads.write'),
('agent', 'members.read'),
('agent', 'messages.send'),
('agent', 'orders.read'),
('agent', 'templates.read'),
('agent', 'tickets.read'),
('agent', 'tickets.write'),
('agent', 'workspace.read'),
('analyst', 'agents.read'),
('analyst', 'analytics.read'),
('analyst', 'audit.read'),
('analyst', 'billing.read'),
('analyst', 'bookings.read'),
('analyst', 'campaigns.read'),
('analyst', 'channels.read'),
('analyst', 'contacts.read'),
('analyst', 'conversations.read'),
('analyst', 'knowledge.read'),
('analyst', 'leads.read'),
('analyst', 'members.read'),
('analyst', 'orders.read'),
('analyst', 'templates.read'),
('analyst', 'tickets.read'),
('analyst', 'workspace.read'),
('viewer', 'agents.read'),
('viewer', 'analytics.read'),
('viewer', 'audit.read'),
('viewer', 'billing.read'),
('viewer', 'bookings.read'),
('viewer', 'campaigns.read'),
('viewer', 'channels.read'),
('viewer', 'contacts.read'),
('viewer', 'conversations.read'),
('viewer', 'flows.read'),
('viewer', 'knowledge.read'),
('viewer', 'leads.read'),
('viewer', 'members.read'),
('viewer', 'orders.read'),
('viewer', 'templates.read'),
('viewer', 'tickets.read'),
('viewer', 'workspace.read');

-- --------------------------------------------------------

--
-- Table structure for table `schema_migrations`
--

CREATE TABLE `schema_migrations` (
  `id` varchar(191) NOT NULL,
  `applied_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `schema_migrations`
--

INSERT INTO `schema_migrations` (`id`, `applied_at`) VALUES
('001_core.sql', '2026-10-20 14:26:54.365'),
('002_messaging.sql', '2026-10-20 14:26:54.626'),
('003_knowledge_flows.sql', '2026-10-20 14:26:54.800'),
('004_commerce.sql', '2026-10-20 14:26:55.102'),
('005_customer_portal.sql', '2026-10-21 22:08:49.104'),
('006_openwa_channel.sql', '2026-10-21 22:08:49.131'),
('007_knowledge_file_formats.sql', '2026-10-29 20:03:00.204'),
('008_knowledge_message_attachments.sql', '2026-10-29 20:03:00.241'),
('009_user_whatsapp_verification.sql', '2026-10-29 20:03:00.257'),
('010_industry_templates.sql', '2026-10-30 20:22:44.166');

-- --------------------------------------------------------

--
-- Table structure for table `support_tickets`
--

CREATE TABLE `support_tickets` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `conversation_id` varchar(36) DEFAULT NULL,
  `contact_id` varchar(36) DEFAULT NULL,
  `subject` varchar(255) NOT NULL,
  `category` varchar(64) DEFAULT NULL,
  `priority` enum('low','normal','high','urgent') NOT NULL DEFAULT 'normal',
  `status` enum('new','open','pending','resolved','closed') NOT NULL DEFAULT 'new',
  `assigned_to` varchar(36) DEFAULT NULL,
  `resolution_summary` text DEFAULT NULL,
  `escalated_at` datetime(3) DEFAULT NULL,
  `resolved_at` datetime(3) DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `templates`
--

CREATE TABLE `templates` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `channel_type` enum('whatsapp','telegram','email','website') NOT NULL,
  `name` varchar(191) NOT NULL,
  `language` varchar(16) NOT NULL DEFAULT 'en',
  `category` varchar(64) DEFAULT NULL,
  `body` text NOT NULL,
  `variables` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`variables`)),
  `provider_status` enum('not_submitted','pending','approved','rejected') NOT NULL DEFAULT 'not_submitted',
  `provider_template_id` varchar(191) DEFAULT NULL,
  `rejection_reason` varchar(255) DEFAULT NULL,
  `created_by` varchar(36) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `templates`
--

INSERT INTO `templates` (`id`, `workspace_id`, `channel_type`, `name`, `language`, `category`, `body`, `variables`, `provider_status`, `provider_template_id`, `rejection_reason`, `created_by`, `created_at`, `updated_at`) VALUES
('ed993aa9-d368-4228-a234-95315fa0c522', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'whatsapp', 'Greeting', 'en', NULL, 'x', NULL, 'not_submitted', NULL, NULL, '83a96de8-003d-438e-8cb8-b79e6abadbd1', '2026-10-24 14:42:19.863', '2026-10-24 14:42:19.863');

-- --------------------------------------------------------

--
-- Table structure for table `ticket_events`
--

CREATE TABLE `ticket_events` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `ticket_id` varchar(36) NOT NULL,
  `event_type` enum('created','status_change','assignment','escalation','note') NOT NULL,
  `from_value` varchar(64) DEFAULT NULL,
  `to_value` varchar(64) DEFAULT NULL,
  `actor_user_id` varchar(36) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ticket_notes`
--

CREATE TABLE `ticket_notes` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `ticket_id` varchar(36) NOT NULL,
  `author_user_id` varchar(36) DEFAULT NULL,
  `body` text NOT NULL,
  `visibility` enum('internal','public') NOT NULL DEFAULT 'internal',
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tool_executions`
--

CREATE TABLE `tool_executions` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `conversation_id` varchar(36) DEFAULT NULL,
  `flow_run_id` varchar(36) DEFAULT NULL,
  `agent_id` varchar(36) DEFAULT NULL,
  `tool_key` varchar(96) NOT NULL,
  `handler` varchar(64) NOT NULL,
  `input` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`input`)),
  `output` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`output`)),
  `status` enum('running','succeeded','failed','denied') NOT NULL DEFAULT 'running',
  `error` text DEFAULT NULL,
  `duration_ms` int(11) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `finished_at` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tool_executions`
--

INSERT INTO `tool_executions` (`id`, `workspace_id`, `conversation_id`, `flow_run_id`, `agent_id`, `tool_key`, `handler`, `input`, `output`, `status`, `error`, `duration_ms`, `created_at`, `finished_at`) VALUES
('0800ee73-f061-4ff9-83d9-9afbc2ab1818', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '75174959-d544-4410-b7bc-0f232f990a12', NULL, '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'search_knowledge', 'search_knowledge', '{\"query\":\"pricing plans\"}', '{\"found\":false,\"passages\":[],\"diagnostics\":{\"query\":\"pricing plans\",\"keywordCandidates\":0,\"vectorCandidates\":0,\"merged\":0,\"returned\":0,\"embeddingModel\":null,\"embeddingsAvailable\":true,\"elapsedMs\":0,\"notes\":[\"no ready knowledge sources for this workspace/agent\"]}}', 'succeeded', NULL, 0, '2026-10-31 16:49:40.674', '2026-10-31 16:49:40.674'),
('770022e7-4726-4104-94e9-0c3d956dca2c', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '75174959-d544-4410-b7bc-0f232f990a12', NULL, '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'search_knowledge', 'search_knowledge', '{\"query\":\"bot reply plan pricing features\"}', '{\"found\":false,\"passages\":[],\"diagnostics\":{\"query\":\"bot reply plan pricing features\",\"keywordCandidates\":0,\"vectorCandidates\":0,\"merged\":0,\"returned\":0,\"embeddingModel\":null,\"embeddingsAvailable\":true,\"elapsedMs\":0,\"notes\":[\"no ready knowledge sources for this workspace/agent\"]}}', 'succeeded', NULL, 1, '2026-10-31 16:49:39.149', '2026-10-31 16:49:39.149'),
('8f1f90ab-4a69-46f5-88f3-74ff679f91fd', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', NULL, NULL, '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 'search_knowledge', 'search_knowledge', '{\"query\":\"Python\"}', '{\"found\":false,\"passages\":[],\"diagnostics\":{\"query\":\"Python\",\"keywordCandidates\":0,\"vectorCandidates\":0,\"merged\":0,\"returned\":0,\"embeddingModel\":null,\"embeddingsAvailable\":true,\"elapsedMs\":0,\"notes\":[\"no ready knowledge sources for this workspace/agent\"]}}', 'succeeded', NULL, 2, '2026-10-29 12:10:49.461', '2026-10-29 12:10:49.461');

-- --------------------------------------------------------

--
-- Table structure for table `usage_events`
--

CREATE TABLE `usage_events` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `agent_id` varchar(36) DEFAULT NULL,
  `agent_version` int(11) DEFAULT NULL,
  `kind` enum('llm_call','tokens_in','tokens_out','embedding_call','documents_indexed','message_outbound') NOT NULL,
  `provider` varchar(48) DEFAULT NULL,
  `model` varchar(96) DEFAULT NULL,
  `quantity` double NOT NULL DEFAULT 0,
  `cost_estimate` double NOT NULL DEFAULT 0,
  `correlation_id` varchar(64) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `usage_events`
--

INSERT INTO `usage_events` (`id`, `workspace_id`, `agent_id`, `agent_version`, `kind`, `provider`, `model`, `quantity`, `cost_estimate`, `correlation_id`, `created_at`) VALUES
('00112b08-d99c-4b81-a468-a8ad8afc744e', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', NULL, NULL, 'message_outbound', 'telegram', NULL, 1, 0, NULL, '2026-10-31 16:49:01.013'),
('0226eb34-110c-46c9-9ed5-e9d4f26518be', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_out', 'openai', 'gpt-5.4-mini', 8, 0, 'db4881ac-4a75-4443-8087-33406b20e469', '2026-10-20 11:31:50.344'),
('02921bee-3e1d-48f3-97af-9040b981230f', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'llm_call', 'openai', 'gemini-3-flash-preview', 1, 0, 'a94e6fa5-95de-4a48-bbae-80d1195481d8', '2026-10-31 16:49:39.136'),
('065b7ade-af0e-4785-9060-b3a9279584b6', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_in', 'openai', 'gpt-5.4-mini', 390, 0, 'a3538571-0f9a-4b66-9077-598cc8972f01', '2026-10-20 11:54:30.677'),
('0c22aac1-0e9a-4b5e-b709-ab0dbce605d6', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '0d72efde-f505-4f96-ac6d-e04235842656', 1, 'tokens_in', 'openai', 'gemini-3-flash-preview', 252, 0, '500ff41e-d5e7-4c47-98cb-317c0b06562f', '2026-10-29 11:31:34.054'),
('10c91403-2ed7-455b-ba44-96fb8401bdf0', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', NULL, NULL, 'message_outbound', 'telegram', NULL, 1, 0, NULL, '2026-10-31 16:48:51.129'),
('138299a5-be70-4a0d-8352-ff6370e072b6', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_out', 'openai', 'gemini-3-flash-preview', 20, 0, 'a94e6fa5-95de-4a48-bbae-80d1195481d8', '2026-10-31 16:49:39.142'),
('14ce1340-c8a3-4f63-8cfa-1dcc0a4083c7', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_out', 'openai', 'gpt-5.4-mini', 54, 0, 'cdb3a7c0-1bac-4cf5-a71f-e66d63d0530e', '2026-10-20 11:55:04.321'),
('186a3f42-4a51-42dd-b78e-ad4cdba5079d', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_out', 'openai', 'gpt-5.4-mini', 24, 0, 'a3538571-0f9a-4b66-9077-598cc8972f01', '2026-10-20 11:54:30.682'),
('1b01384c-71a1-4282-858a-3305d2f38210', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'f803b4a0-5da6-4912-ba1d-4a8fb2af9638', 1, 'tokens_out', 'openai', 'gemini-3-flash-preview', 38, 0, '4349d62b-87e5-4548-8856-4934044ff193', '2026-10-29 14:03:03.070'),
('216fac3d-0b84-4679-bf70-5f4163707f5d', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'llm_call', 'openai', 'gemini-3-flash-preview', 1, 0, '54f6d8a1-6c8b-4b29-8263-4404428f1379', '2026-10-29 12:10:52.149'),
('217e97c4-84e3-4c3f-83e8-3b0f569032db', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_out', 'openai', 'gemini-3-flash-preview', 41, 0, 'f4a561ec-c386-4d4a-85da-da31641ae656', '2026-10-31 16:48:58.185'),
('284b4a05-9694-43e3-b99a-bcc996462a09', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_out', 'openai', 'gemini-3-flash-preview', 42, 0, 'c90de37b-1e5a-47ff-a1f3-b5853e48f0c0', '2026-10-29 12:10:13.774'),
('28a6410c-8dfc-47b5-9c19-e9b4689ab7b0', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'llm_call', 'openai', 'gpt-5.4-mini', 1, 0, 'cdb3a7c0-1bac-4cf5-a71f-e66d63d0530e', '2026-10-20 11:55:04.317'),
('2b961593-4a34-49c9-a5f2-bdb734f1eadf', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'llm_call', 'openai', 'gemini-3-flash-preview', 1, 0, 'a94e6fa5-95de-4a48-bbae-80d1195481d8', '2026-10-31 16:49:40.668'),
('325381cd-ac4e-4253-871f-d3ec54b334ec', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'f803b4a0-5da6-4912-ba1d-4a8fb2af9638', 1, 'llm_call', 'openai', 'gemini-3-flash-preview', 1, 0, '4349d62b-87e5-4548-8856-4934044ff193', '2026-10-29 14:03:03.058'),
('38c914d5-95e9-4c4a-9837-85151c248e43', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_out', 'openai', 'gemini-3-flash-preview', 17, 0, 'a94e6fa5-95de-4a48-bbae-80d1195481d8', '2026-10-31 16:49:40.671'),
('3cb01662-e601-46a4-8f8a-470412b51fe0', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'llm_call', 'openai', 'gemini-3-flash-preview', 1, 0, '99b35a05-faed-42dd-b806-91f9b9897367', '2026-10-31 16:48:49.447'),
('3facb9ef-9adc-4625-9d01-30cd99b9ba64', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_in', 'openai', 'gemini-3-flash-preview', 611, 0, '54f6d8a1-6c8b-4b29-8263-4404428f1379', '2026-10-29 12:10:52.152'),
('4846e326-c667-47e9-89e2-8ec8075f60d1', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_in', 'openai', 'gemini-3-flash-preview', 399, 0, 'f4a561ec-c386-4d4a-85da-da31641ae656', '2026-10-31 16:48:58.180'),
('51f6d0a7-9682-481c-aa74-bff4e7c235ee', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_in', 'openai', 'gemini-3-flash-preview', 451, 0, 'a94e6fa5-95de-4a48-bbae-80d1195481d8', '2026-10-31 16:49:39.140'),
('581365ac-6a8d-4139-b66d-c714034791b8', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_out', 'openai', 'gemini-3-flash-preview', 57, 0, '99b35a05-faed-42dd-b806-91f9b9897367', '2026-10-31 16:48:49.456'),
('5837c648-9204-4ef9-bac6-2ce03d62e90d', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_out', 'openai', 'gemini-3-flash-preview', 69, 0, '54f6d8a1-6c8b-4b29-8263-4404428f1379', '2026-10-29 12:10:52.156'),
('592aac8b-31a2-44db-955d-12137f2b3a24', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'llm_call', 'openai', 'gemini-3-flash-preview', 1, 0, 'a94e6fa5-95de-4a48-bbae-80d1195481d8', '2026-10-31 16:49:42.101'),
('5cd28b3b-7014-45f2-8305-f68c921a00a2', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '0d72efde-f505-4f96-ac6d-e04235842656', 1, 'llm_call', 'openai', 'gemini-3-flash-preview', 1, 0, '500ff41e-d5e7-4c47-98cb-317c0b06562f', '2026-10-29 11:31:34.050'),
('61f93b65-68d6-49bd-8b3a-33b7cc93d169', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_out', 'openai', 'gemini-3-flash-preview', 68, 0, 'a94e6fa5-95de-4a48-bbae-80d1195481d8', '2026-10-31 16:49:42.108'),
('63d398db-b88b-45fb-9cea-acd740c8e155', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '0d72efde-f505-4f96-ac6d-e04235842656', 1, 'tokens_out', 'openai', 'gpt-5.4-mini', 143, 0, 'db1ebcb4-1248-4013-afa0-61b795c1780c', '2026-10-20 16:05:47.477'),
('658a0418-079d-4b0a-b3e4-d3af7e008c85', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'llm_call', 'openai', 'gemini-3-flash-preview', 1, 0, '54f6d8a1-6c8b-4b29-8263-4404428f1379', '2026-10-29 12:10:49.321'),
('71156c92-3635-4d03-a638-f012709585bf', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'llm_call', 'openai', 'gpt-5.4-mini', 1, 0, 'a3538571-0f9a-4b66-9077-598cc8972f01', '2026-10-20 11:54:30.674'),
('82b092e3-411d-4ce5-9415-1013f09cf173', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_in', 'openai', 'gemini-3-flash-preview', 813, 0, 'a94e6fa5-95de-4a48-bbae-80d1195481d8', '2026-10-31 16:49:42.105'),
('85e58b64-7733-4ded-9ffb-1530028b47aa', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '0d72efde-f505-4f96-ac6d-e04235842656', 1, 'tokens_in', 'openai', 'gemini-3-flash-preview', 286, 0, 'a6df9a4b-eac9-4521-a350-7660edbbe64a', '2026-10-29 11:50:19.756'),
('8978901e-6c2b-424e-b8f9-1bd33952e1b5', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'llm_call', 'openai', 'gemini-3-flash-preview', 1, 0, 'f4a561ec-c386-4d4a-85da-da31641ae656', '2026-10-31 16:48:58.178'),
('919d72a3-de81-4a81-8c83-8aa4ca60b1e8', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_in', 'openai', 'gemini-3-flash-preview', 346, 0, '54f6d8a1-6c8b-4b29-8263-4404428f1379', '2026-10-29 12:10:49.328'),
('91d0eb6a-70f5-4a22-ac63-4868fda3aea9', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '0d72efde-f505-4f96-ac6d-e04235842656', 1, 'tokens_in', 'openai', 'gpt-5.4-mini', 276, 0, 'db1ebcb4-1248-4013-afa0-61b795c1780c', '2026-10-20 16:05:47.474'),
('b301ccbb-058e-47bc-b11f-ede97c54e7d5', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '0d72efde-f505-4f96-ac6d-e04235842656', 1, 'tokens_out', 'openai', 'gemini-3-flash-preview', 43, 0, 'a6df9a4b-eac9-4521-a350-7660edbbe64a', '2026-10-29 11:50:19.768'),
('b392461d-28f4-4598-9301-b4d6c5403266', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_out', 'openai', 'gemini-3-flash-preview', 16, 0, '54f6d8a1-6c8b-4b29-8263-4404428f1379', '2026-10-29 12:10:49.380'),
('bbfc2886-98e3-406c-91b6-694e631a18b4', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '0d72efde-f505-4f96-ac6d-e04235842656', 1, 'llm_call', 'openai', 'gemini-3-flash-preview', 1, 0, 'a6df9a4b-eac9-4521-a350-7660edbbe64a', '2026-10-29 11:50:19.741'),
('c304a417-0ee5-4287-a691-c2dfa3187ba2', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', 'f803b4a0-5da6-4912-ba1d-4a8fb2af9638', 1, 'tokens_in', 'openai', 'gemini-3-flash-preview', 105, 0, '4349d62b-87e5-4548-8856-4934044ff193', '2026-10-29 14:03:03.066'),
('c74b9d9d-e6ba-4ef4-be68-ba5c09f617ef', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'llm_call', 'openai', 'gpt-5.4-mini', 1, 0, 'db4881ac-4a75-4443-8087-33406b20e469', '2026-10-20 11:31:50.339'),
('c9374768-e8ea-4a84-af18-373aebe43ee9', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', NULL, NULL, 'message_outbound', 'telegram', NULL, 1, 0, NULL, '2026-10-31 16:49:43.653'),
('d209cac4-d973-4ac4-8f11-754199dde105', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_in', 'openai', 'gemini-3-flash-preview', 612, 0, 'a94e6fa5-95de-4a48-bbae-80d1195481d8', '2026-10-31 16:49:40.669'),
('d29b8f1d-7441-4d23-86a8-0db52a06b209', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '0d72efde-f505-4f96-ac6d-e04235842656', 1, 'llm_call', 'openai', 'gpt-5.4-mini', 1, 0, 'db1ebcb4-1248-4013-afa0-61b795c1780c', '2026-10-20 16:05:47.470'),
('d3086d50-99da-4f47-bf4d-72f0a34679af', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '0d72efde-f505-4f96-ac6d-e04235842656', 1, 'tokens_out', 'openai', 'gemini-3-flash-preview', 31, 0, '500ff41e-d5e7-4c47-98cb-317c0b06562f', '2026-10-29 11:31:34.057'),
('da65b64c-a91d-4afc-b57d-10955269537b', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', NULL, NULL, 'message_outbound', 'website', NULL, 1, 0, NULL, '2026-10-20 16:05:48.279'),
('df47181c-8544-488b-812b-b0ca5b4cfa91', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_in', 'openai', 'gemini-3-flash-preview', 300, 0, 'c90de37b-1e5a-47ff-a1f3-b5853e48f0c0', '2026-10-29 12:10:13.772'),
('e72df6d1-341d-45cd-9edb-dee799c7ebcb', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_in', 'openai', 'gemini-3-flash-preview', 339, 0, '99b35a05-faed-42dd-b806-91f9b9897367', '2026-10-31 16:48:49.453'),
('eb2a3761-d99a-4d77-ad9e-d1457cc8e9a3', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'llm_call', 'openai', 'gemini-3-flash-preview', 1, 0, 'c90de37b-1e5a-47ff-a1f3-b5853e48f0c0', '2026-10-29 12:10:13.770'),
('ecd8cf33-a3a3-4e8b-a58a-eecf6b61653c', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_in', 'openai', 'gpt-5.4-mini', 247, 0, 'db4881ac-4a75-4443-8087-33406b20e469', '2026-10-20 11:31:50.342'),
('ef9fa945-5dde-42b7-890f-59b9465180db', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '96600822-c3a4-4bca-85ce-4faeda9b7a8b', 1, 'tokens_in', 'openai', 'gpt-5.4-mini', 461, 0, 'cdb3a7c0-1bac-4cf5-a71f-e66d63d0530e', '2026-10-20 11:55:04.319'),
('ue-1', 'ws-1', NULL, NULL, 'llm_call', 'openai', 'gpt-4o', 50, 0.05, 'corr-1', '2026-10-29 14:33:00.338'),
('ue-2', 'ws-1', NULL, NULL, 'tokens_in', 'openai', 'gpt-4o', 1000, 0.01, 'corr-2', '2026-10-29 14:33:00.338'),
('ue-3', 'ws-2', NULL, NULL, 'message_outbound', 'whatsapp', NULL, 1, 0.005, 'corr-3', '2026-10-29 14:33:00.338');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` varchar(36) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `status` enum('active','invited','suspended') NOT NULL DEFAULT 'active',
  `email_verified_at` datetime(3) DEFAULT NULL,
  `last_login_at` datetime(3) DEFAULT NULL,
  `failed_login_count` int(11) NOT NULL DEFAULT 0,
  `locked_until` datetime(3) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password_hash`, `name`, `status`, `email_verified_at`, `last_login_at`, `failed_login_count`, `locked_until`, `created_at`, `updated_at`) VALUES
('4a566cd7-129e-420b-bb95-4c2e11b29b99', 'analyst@botreply.local', '$2a$10$0XhaXY2Mb9TEGYOUXB3YTu9u0GEwVl8IUpDzoB/ODRj3vGtBtxN4S', 'Demo Analyst', 'active', '2026-10-20 08:59:41.631', NULL, 0, NULL, '2026-10-20 08:59:41.631', '2026-10-20 08:59:41.631'),
('567797f6-c8d3-4ea0-b53a-19838a82f44a', 'viewer@botreply.local', '$2a$10$eAh5sQlpxs3Q.ADiwKZqzeN1imu3/XP8UA4EFs95dGQIaPz2YC7YK', 'Demo Viewer', 'active', '2026-10-20 08:59:41.728', '2026-10-20 12:02:51.983', 0, NULL, '2026-10-20 08:59:41.728', '2026-10-20 12:02:51.983'),
('59627376-d414-4b33-a8c5-756cf5d231a1', 'admin@botreply.local', '$2a$10$bDQUkk4bEXypgZdBHEK4y.zi7PK06n6OUb5D5RJjNHMoB.H9P31uu', 'Demo Admin', 'active', '2026-10-20 08:59:41.413', '2026-10-30 11:20:10.520', 0, NULL, '2026-10-20 08:59:41.413', '2026-10-30 11:20:10.520'),
('78f88de2-49db-4994-9db3-4e190abefe46', 'bhupendra@test.com', '$2a$10$hNu7sSVxXOZFBUQIX2/XsuSAbkqQWF9lMFHrEW0CFKth3zsuw5UgK', 'bhupendra', 'active', NULL, NULL, 0, NULL, '2026-10-22 08:52:46.112', '2026-10-22 08:52:46.112'),
('83a96de8-003d-438e-8cb8-b79e6abadbd1', 'demo@botreply.local', '$2a$10$z2t6ILXsIe6UA09w4NuSEeqhupgn/AImwB7YyBuUG5R.4QWLGmF8i', 'Demo Owner', 'active', '2026-10-20 08:57:48.193', '2026-10-31 16:46:05.490', 0, NULL, '2026-10-20 08:57:48.193', '2026-10-31 16:46:05.490'),
('8658f0fc-a05a-4123-9061-cb7b45878e04', 'manager@botreply.local', '$2a$10$aWOJCvrhbv1/UQZJj4uMlOfYHhhBnuJzuJv55wA1h2Z0KEpybkdD2', 'Demo Manager', 'active', '2026-10-20 08:59:41.487', NULL, 0, NULL, '2026-10-20 08:59:41.487', '2026-10-20 08:59:41.487'),
('f5a31fab-043e-4859-8a46-ac19fb67796d', 'agent@botreply.local', '$2a$10$RiBcRy20xxcwkgK2ZlTlK.8gEq/OAQVEjrkVy3k.OcNzBSXVHbFOe', 'Demo Agent', 'active', '2026-10-20 08:59:41.561', NULL, 0, NULL, '2026-10-20 08:59:41.561', '2026-10-20 08:59:41.561'),
('user-1', 'test1@example.com', '$2a$10$N.zQwD3YzQpJ5qL.i5e9CuuF8x.wx.WFl6wF4.HeHOqGzB8/2qJCu', 'Test User 1', 'active', '2026-10-29 14:33:00.261', NULL, 0, NULL, '2026-10-29 14:33:00.261', '2026-10-29 14:33:00.261'),
('user-2', 'test2@example.com', '$2a$10$N.zQwD3YzQpJ5qL.i5e9CuuF8x.wx.WFl6wF4.HeHOqGzB8/2qJCu', 'Test User 2', 'active', '2026-10-29 14:33:00.261', NULL, 0, NULL, '2026-10-29 14:33:00.261', '2026-10-29 14:33:00.261'),
('user-3', 'test3@example.com', '$2a$10$N.zQwD3YzQpJ5qL.i5e9CuuF8x.wx.WFl6wF4.HeHOqGzB8/2qJCu', 'Test User 3', 'active', '2026-10-29 14:33:00.261', NULL, 0, NULL, '2026-10-29 14:33:00.261', '2026-10-29 14:33:00.261');

-- --------------------------------------------------------

--
-- Table structure for table `user_whatsapp_verifications`
--

CREATE TABLE `user_whatsapp_verifications` (
  `user_id` varchar(36) NOT NULL,
  `phone_enc` text DEFAULT NULL,
  `code_hash` char(64) DEFAULT NULL,
  `expires_at` datetime(3) DEFAULT NULL,
  `last_sent_at` datetime(3) DEFAULT NULL,
  `window_started_at` datetime(3) DEFAULT NULL,
  `send_count` int(11) NOT NULL DEFAULT 0,
  `verify_attempts` int(11) NOT NULL DEFAULT 0,
  `verified_at` datetime(3) DEFAULT NULL,
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `webhook_events`
--

CREATE TABLE `webhook_events` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) DEFAULT NULL,
  `channel_id` varchar(36) DEFAULT NULL,
  `provider` varchar(64) NOT NULL,
  `external_event_id` varchar(191) NOT NULL,
  `signature_valid` tinyint(1) NOT NULL DEFAULT 0,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`payload`)),
  `status` enum('received','processed','failed','duplicate','rejected') NOT NULL DEFAULT 'received',
  `error` text DEFAULT NULL,
  `received_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `processed_at` datetime(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `widget_sessions`
--

CREATE TABLE `widget_sessions` (
  `id` varchar(36) NOT NULL,
  `workspace_id` varchar(36) NOT NULL,
  `channel_id` varchar(36) NOT NULL,
  `visitor_id` varchar(64) NOT NULL,
  `contact_id` varchar(36) DEFAULT NULL,
  `conversation_id` varchar(36) DEFAULT NULL,
  `token_hash` varchar(64) NOT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `ip` varchar(64) DEFAULT NULL,
  `last_seen_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `widget_sessions`
--

INSERT INTO `widget_sessions` (`id`, `workspace_id`, `channel_id`, `visitor_id`, `contact_id`, `conversation_id`, `token_hash`, `user_agent`, `ip`, `last_seen_at`, `created_at`) VALUES
('5a90b500-3f9d-4918-aa60-8d1e98f441f6', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '867f36e8-1055-4685-9a2d-62fb410d4b05', 'd6814b70-292b-4c81-8edc-15475f25a6c8', NULL, NULL, '7709a30428fadbfb5fc22283012bd5d816eb21678ea05a26491c425e33f059fa', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.138.0 Chrome/148.0.7778.280 Electron/42.10.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 16:17:18.559', '2026-10-20 16:16:51.004'),
('5cf620a5-5ad2-4590-b3c5-6c9e21359de2', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '867f36e8-1055-4685-9a2d-62fb410d4b05', '997d0f82-5bec-42f9-aad1-ec3761204ac5', NULL, NULL, 'c8c67adec63cb02cab61a8f7b023d51e868a65e0ef07181b04f781f2b6ef6edc', 'Mozilla/5.0 (Windows NT; Windows NT 10.0; en-IN) WindowsPowerShell/5.1.26100.9711', '::ffff:127.0.0.1', '2026-10-22 08:53:10.701', '2026-10-22 08:53:10.701'),
('a8a661c6-f2a5-4e98-b954-9ba241bb9e3f', 'a046f159-d232-41ac-a686-a88e8f9ff2b5', '867f36e8-1055-4685-9a2d-62fb410d4b05', '080c0bcd-a2a9-4e28-a2a4-101999336c57', NULL, '6fa45e74-50d3-47a7-a74e-79020d0fa2d1', '001f990382607a87844c232b6bcc84b6a521a56d4309fee79390d26ca0d1f14e', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/155.0.0.0 Safari/537.36', '::ffff:127.0.0.1', '2026-10-20 16:07:55.795', '2026-10-20 16:05:35.745');

-- --------------------------------------------------------

--
-- Table structure for table `workspaces`
--

CREATE TABLE `workspaces` (
  `id` varchar(36) NOT NULL,
  `name` varchar(191) NOT NULL,
  `slug` varchar(191) NOT NULL,
  `owner_user_id` varchar(36) NOT NULL,
  `plan` enum('free','starter','pro','enterprise') NOT NULL DEFAULT 'free',
  `status` enum('active','suspended','deleted') NOT NULL DEFAULT 'active',
  `settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`settings`)),
  `created_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updated_at` datetime(3) NOT NULL DEFAULT current_timestamp(3) ON UPDATE current_timestamp(3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `workspaces`
--

INSERT INTO `workspaces` (`id`, `name`, `slug`, `owner_user_id`, `plan`, `status`, `settings`, `created_at`, `updated_at`) VALUES
('951f0dbc-1a1f-44ed-aa74-e828ee8d6953', 'Test', 'test', '78f88de2-49db-4994-9db3-4e190abefe46', 'free', 'active', '{}', '2026-10-22 08:52:46.135', '2026-10-22 08:52:46.135');
INSERT INTO `workspaces` (`id`, `name`, `slug`, `owner_user_id`, `plan`, `status`, `settings`, `created_at`, `updated_at`) VALUES
('a046f159-d232-41ac-a686-a88e8f9ff2b5', 'Demo workspace', 'demo-workspace', '83a96de8-003d-438e-8cb8-b79e6abadbd1', 'enterprise', 'active', '{\"0\":\"{\",\"1\":\"\\\"\",\"2\":\"0\",\"3\":\"\\\"\",\"4\":\":\",\"5\":\"\\\"\",\"6\":\"{\",\"7\":\"\\\"\",\"8\":\",\",\"9\":\"\\\"\",\"10\":\"1\",\"11\":\"\\\"\",\"12\":\":\",\"13\":\"\\\"\",\"14\":\"\\\\\",\"15\":\"\\\"\",\"16\":\"\\\"\",\"17\":\",\",\"18\":\"\\\"\",\"19\":\"2\",\"20\":\"\\\"\",\"21\":\":\",\"22\":\"\\\"\",\"23\":\"0\",\"24\":\"\\\"\",\"25\":\",\",\"26\":\"\\\"\",\"27\":\"3\",\"28\":\"\\\"\",\"29\":\":\",\"30\":\"\\\"\",\"31\":\"\\\\\",\"32\":\"\\\"\",\"33\":\"\\\"\",\"34\":\",\",\"35\":\"\\\"\",\"36\":\"4\",\"37\":\"\\\"\",\"38\":\":\",\"39\":\"\\\"\",\"40\":\":\",\"41\":\"\\\"\",\"42\":\",\",\"43\":\"\\\"\",\"44\":\"5\",\"45\":\"\\\"\",\"46\":\":\",\"47\":\"\\\"\",\"48\":\"\\\\\",\"49\":\"\\\"\",\"50\":\"\\\"\",\"51\":\",\",\"52\":\"\\\"\",\"53\":\"6\",\"54\":\"\\\"\",\"55\":\":\",\"56\":\"\\\"\",\"57\":\"{\",\"58\":\"\\\"\",\"59\":\",\",\"60\":\"\\\"\",\"61\":\"7\",\"62\":\"\\\"\",\"63\":\":\",\"64\":\"\\\"\",\"65\":\"\\\\\",\"66\":\"\\\"\",\"67\":\"\\\"\",\"68\":\",\",\"69\":\"\\\"\",\"70\":\"8\",\"71\":\"\\\"\",\"72\":\":\",\"73\":\"\\\"\",\"74\":\",\",\"75\":\"\\\"\",\"76\":\",\",\"77\":\"\\\"\",\"78\":\"9\",\"79\":\"\\\"\",\"80\":\":\",\"81\":\"\\\"\",\"82\":\"\\\\\",\"83\":\"\\\"\",\"84\":\"\\\"\",\"85\":\",\",\"86\":\"\\\"\",\"87\":\"1\",\"88\":\"0\",\"89\":\"\\\"\",\"90\":\":\",\"91\":\"\\\"\",\"92\":\"1\",\"93\":\"\\\"\",\"94\":\",\",\"95\":\"\\\"\",\"96\":\"1\",\"97\":\"1\",\"98\":\"\\\"\",\"99\":\":\",\"100\":\"\\\"\",\"101\":\"\\\\\",\"102\":\"\\\"\",\"103\":\"\\\"\",\"104\":\",\",\"105\":\"\\\"\",\"106\":\"1\",\"107\":\"2\",\"108\":\"\\\"\",\"109\":\":\",\"110\":\"\\\"\",\"111\":\":\",\"112\":\"\\\"\",\"113\":\",\",\"114\":\"\\\"\",\"115\":\"1\",\"116\":\"3\",\"117\":\"\\\"\",\"118\":\":\",\"119\":\"\\\"\",\"120\":\"\\\\\",\"121\":\"\\\"\",\"122\":\"\\\"\",\"123\":\",\",\"124\":\"\\\"\",\"125\":\"1\",\"126\":\"4\",\"127\":\"\\\"\",\"128\":\":\",\"129\":\"\\\"\",\"130\":\"\\\\\",\"131\":\"\\\\\",\"132\":\"\\\"\",\"133\":\",\",\"134\":\"\\\"\",\"135\":\"1\",\"136\":\"5\",\"137\":\"\\\"\",\"138\":\":\",\"139\":\"\\\"\",\"140\":\"\\\\\",\"141\":\"\\\"\",\"142\":\"\\\"\",\"143\":\",\",\"144\":\"\\\"\",\"145\":\"1\",\"146\":\"6\",\"147\":\"\\\"\",\"148\":\":\",\"149\":\"\\\"\",\"150\":\"\\\\\",\"151\":\"\\\"\",\"152\":\"\\\"\",\"153\":\",\",\"154\":\"\\\"\",\"155\":\"1\",\"156\":\"7\",\"157\":\"\\\"\",\"158\":\":\",\"159\":\"\\\"\",\"160\":\",\",\"161\":\"\\\"\",\"162\":\",\",\"163\":\"\\\"\",\"164\":\"1\",\"165\":\"8\",\"166\":\"\\\"\",\"167\":\":\",\"168\":\"\\\"\",\"169\":\"\\\\\",\"170\":\"\\\"\",\"171\":\"\\\"\",\"172\":\",\",\"173\":\"\\\"\",\"174\":\"1\",\"175\":\"9\",\"176\":\"\\\"\",\"177\":\":\",\"178\":\"\\\"\",\"179\":\"2\",\"180\":\"\\\"\",\"181\":\",\",\"182\":\"\\\"\",\"183\":\"2\",\"184\":\"0\",\"185\":\"\\\"\",\"186\":\":\",\"187\":\"\\\"\",\"188\":\"\\\\\",\"189\":\"\\\"\",\"190\":\"\\\"\",\"191\":\",\",\"192\":\"\\\"\",\"193\":\"2\",\"194\":\"1\",\"195\":\"\\\"\",\"196\":\":\",\"197\":\"\\\"\",\"198\":\":\",\"199\":\"\\\"\",\"200\":\",\",\"201\":\"\\\"\",\"202\":\"2\",\"203\":\"2\",\"204\":\"\\\"\",\"205\":\":\",\"206\":\"\\\"\",\"207\":\"\\\\\",\"208\":\"\\\"\",\"209\":\"\\\"\",\"210\":\",\",\"211\":\"\\\"\",\"212\":\"2\",\"213\":\"3\",\"214\":\"\\\"\",\"215\":\":\",\"216\":\"\\\"\",\"217\":\"t\",\"218\":\"\\\"\",\"219\":\",\",\"220\":\"\\\"\",\"221\":\"2\",\"222\":\"4\",\"223\":\"\\\"\",\"224\":\":\",\"225\":\"\\\"\",\"226\":\"\\\\\",\"227\":\"\\\"\",\"228\":\"\\\"\",\"229\":\",\",\"230\":\"\\\"\",\"231\":\"2\",\"232\":\"5\",\"233\":\"\\\"\",\"234\":\":\",\"235\":\"\\\"\",\"236\":\",\",\"237\":\"\\\"\",\"238\":\",\",\"239\":\"\\\"\",\"240\":\"2\",\"241\":\"6\",\"242\":\"\\\"\",\"243\":\":\",\"244\":\"\\\"\",\"245\":\"\\\\\",\"246\":\"\\\"\",\"247\":\"\\\"\",\"248\":\",\",\"249\":\"\\\"\",\"250\":\"2\",\"251\":\"7\",\"252\":\"\\\"\",\"253\":\":\",\"254\":\"\\\"\",\"255\":\"3\",\"256\":\"\\\"\",\"257\":\",\",\"258\":\"\\\"\",\"259\":\"2\",\"260\":\"8\",\"261\":\"\\\"\",\"262\":\":\",\"263\":\"\\\"\",\"264\":\"\\\\\",\"265\":\"\\\"\",\"266\":\"\\\"\",\"267\":\",\",\"268\":\"\\\"\",\"269\":\"2\",\"270\":\"9\",\"271\":\"\\\"\",\"272\":\":\",\"273\":\"\\\"\",\"274\":\":\",\"275\":\"\\\"\",\"276\":\",\",\"277\":\"\\\"\",\"278\":\"3\",\"279\":\"0\",\"280\":\"\\\"\",\"281\":\":\",\"282\":\"\\\"\",\"283\":\"\\\\\",\"284\":\"\\\"\",\"285\":\"\\\"\",\"286\":\",\",\"287\":\"\\\"\",\"288\":\"3\",\"289\":\"1\",\"290\":\"\\\"\",\"291\":\":\",\"292\":\"\\\"\",\"293\":\"i\",\"294\":\"\\\"\",\"295\":\",\",\"296\":\"\\\"\",\"297\":\"3\",\"298\":\"2\",\"299\":\"\\\"\",\"300\":\":\",\"301\":\"\\\"\",\"302\":\"\\\\\",\"303\":\"\\\"\",\"304\":\"\\\"\",\"305\":\",\",\"306\":\"\\\"\",\"307\":\"3\",\"308\":\"3\",\"309\":\"\\\"\",\"310\":\":\",\"311\":\"\\\"\",\"312\":\",\",\"313\":\"\\\"\",\"314\":\",\",\"315\":\"\\\"\",\"316\":\"3\",\"317\":\"4\",\"318\":\"\\\"\",\"319\":\":\",\"320\":\"\\\"\",\"321\":\"\\\\\",\"322\":\"\\\"\",\"323\":\"\\\"\",\"324\":\",\",\"325\":\"\\\"\",\"326\":\"3\",\"327\":\"5\",\"328\":\"\\\"\",\"329\":\":\",\"330\":\"\\\"\",\"331\":\"4\",\"332\":\"\\\"\",\"333\":\",\",\"334\":\"\\\"\",\"335\":\"3\",\"336\":\"6\",\"337\":\"\\\"\",\"338\":\":\",\"339\":\"\\\"\",\"340\":\"\\\\\",\"341\":\"\\\"\",\"342\":\"\\\"\",\"343\":\",\",\"344\":\"\\\"\",\"345\":\"3\",\"346\":\"7\",\"347\":\"\\\"\",\"348\":\":\",\"349\":\"\\\"\",\"350\":\":\",\"351\":\"\\\"\",\"352\":\",\",\"353\":\"\\\"\",\"354\":\"3\",\"355\":\"8\",\"356\":\"\\\"\",\"357\":\":\",\"358\":\"\\\"\",\"359\":\"\\\\\",\"360\":\"\\\"\",\"361\":\"\\\"\",\"362\":\",\",\"363\":\"\\\"\",\"364\":\"3\",\"365\":\"9\",\"366\":\"\\\"\",\"367\":\":\",\"368\":\"\\\"\",\"369\":\"m\",\"370\":\"\\\"\",\"371\":\",\",\"372\":\"\\\"\",\"373\":\"4\",\"374\":\"0\",\"375\":\"\\\"\",\"376\":\":\",\"377\":\"\\\"\",\"378\":\"\\\\\",\"379\":\"\\\"\",\"380\":\"\\\"\",\"381\":\",\",\"382\":\"\\\"\",\"383\":\"4\",\"384\":\"1\",\"385\":\"\\\"\",\"386\":\":\",\"387\":\"\\\"\",\"388\":\",\",\"389\":\"\\\"\",\"390\":\",\",\"391\":\"\\\"\",\"392\":\"4\",\"393\":\"2\",\"394\":\"\\\"\",\"395\":\":\",\"396\":\"\\\"\",\"397\":\"\\\\\",\"398\":\"\\\"\",\"399\":\"\\\"\",\"400\":\",\",\"401\":\"\\\"\",\"402\":\"4\",\"403\":\"3\",\"404\":\"\\\"\",\"405\":\":\",\"406\":\"\\\"\",\"407\":\"5\",\"408\":\"\\\"\",\"409\":\",\",\"410\":\"\\\"\",\"411\":\"4\",\"412\":\"4\",\"413\":\"\\\"\",\"414\":\":\",\"415\":\"\\\"\",\"416\":\"\\\\\",\"417\":\"\\\"\",\"418\":\"\\\"\",\"419\":\",\",\"420\":\"\\\"\",\"421\":\"4\",\"422\":\"5\",\"423\":\"\\\"\",\"424\":\":\",\"425\":\"\\\"\",\"426\":\":\",\"427\":\"\\\"\",\"428\":\",\",\"429\":\"\\\"\",\"430\":\"4\",\"431\":\"6\",\"432\":\"\\\"\",\"433\":\":\",\"434\":\"\\\"\",\"435\":\"\\\\\",\"436\":\"\\\"\",\"437\":\"\\\"\",\"438\":\",\",\"439\":\"\\\"\",\"440\":\"4\",\"441\":\"7\",\"442\":\"\\\"\",\"443\":\":\",\"444\":\"\\\"\",\"445\":\"e\",\"446\":\"\\\"\",\"447\":\",\",\"448\":\"\\\"\",\"449\":\"4\",\"450\":\"8\",\"451\":\"\\\"\",\"452\":\":\",\"453\":\"\\\"\",\"454\":\"\\\\\",\"455\":\"\\\"\",\"456\":\"\\\"\",\"457\":\",\",\"458\":\"\\\"\",\"459\":\"4\",\"460\":\"9\",\"461\":\"\\\"\",\"462\":\":\",\"463\":\"\\\"\",\"464\":\",\",\"465\":\"\\\"\",\"466\":\",\",\"467\":\"\\\"\",\"468\":\"5\",\"469\":\"0\",\"470\":\"\\\"\",\"471\":\":\",\"472\":\"\\\"\",\"473\":\"\\\\\",\"474\":\"\\\"\",\"475\":\"\\\"\",\"476\":\",\",\"477\":\"\\\"\",\"478\":\"5\",\"479\":\"1\",\"480\":\"\\\"\",\"481\":\":\",\"482\":\"\\\"\",\"483\":\"6\",\"484\":\"\\\"\",\"485\":\",\",\"486\":\"\\\"\",\"487\":\"5\",\"488\":\"2\",\"489\":\"\\\"\",\"490\":\":\",\"491\":\"\\\"\",\"492\":\"\\\\\",\"493\":\"\\\"\",\"494\":\"\\\"\",\"495\":\",\",\"496\":\"\\\"\",\"497\":\"5\",\"498\":\"3\",\"499\":\"\\\"\",\"500\":\":\",\"501\":\"\\\"\",\"502\":\":\",\"503\":\"\\\"\",\"504\":\",\",\"505\":\"\\\"\",\"506\":\"5\",\"507\":\"4\",\"508\":\"\\\"\",\"509\":\":\",\"510\":\"\\\"\",\"511\":\"\\\\\",\"512\":\"\\\"\",\"513\":\"\\\"\",\"514\":\",\",\"515\":\"\\\"\",\"516\":\"5\",\"517\":\"5\",\"518\":\"\\\"\",\"519\":\":\",\"520\":\"\\\"\",\"521\":\"z\",\"522\":\"\\\"\",\"523\":\",\",\"524\":\"\\\"\",\"525\":\"5\",\"526\":\"6\",\"527\":\"\\\"\",\"528\":\":\",\"529\":\"\\\"\",\"530\":\"\\\\\",\"531\":\"\\\"\",\"532\":\"\\\"\",\"533\":\",\",\"534\":\"\\\"\",\"535\":\"5\",\"536\":\"7\",\"537\":\"\\\"\",\"538\":\":\",\"539\":\"\\\"\",\"540\":\",\",\"541\":\"\\\"\",\"542\":\",\",\"543\":\"\\\"\",\"544\":\"5\",\"545\":\"8\",\"546\":\"\\\"\",\"547\":\":\",\"548\":\"\\\"\",\"549\":\"\\\\\",\"550\":\"\\\"\",\"551\":\"\\\"\",\"552\":\",\",\"553\":\"\\\"\",\"554\":\"5\",\"555\":\"9\",\"556\":\"\\\"\",\"557\":\":\",\"558\":\"\\\"\",\"559\":\"7\",\"560\":\"\\\"\",\"561\":\",\",\"562\":\"\\\"\",\"563\":\"6\",\"564\":\"0\",\"565\":\"\\\"\",\"566\":\":\",\"567\":\"\\\"\",\"568\":\"\\\\\",\"569\":\"\\\"\",\"570\":\"\\\"\",\"571\":\",\",\"572\":\"\\\"\",\"573\":\"6\",\"574\":\"1\",\"575\":\"\\\"\",\"576\":\":\",\"577\":\"\\\"\",\"578\":\":\",\"579\":\"\\\"\",\"580\":\",\",\"581\":\"\\\"\",\"582\":\"6\",\"583\":\"2\",\"584\":\"\\\"\",\"585\":\":\",\"586\":\"\\\"\",\"587\":\"\\\\\",\"588\":\"\\\"\",\"589\":\"\\\"\",\"590\":\",\",\"591\":\"\\\"\",\"592\":\"6\",\"593\":\"3\",\"594\":\"\\\"\",\"595\":\":\",\"596\":\"\\\"\",\"597\":\"o\",\"598\":\"\\\"\",\"599\":\",\",\"600\":\"\\\"\",\"601\":\"6\",\"602\":\"4\",\"603\":\"\\\"\",\"604\":\":\",\"605\":\"\\\"\",\"606\":\"\\\\\",\"607\":\"\\\"\",\"608\":\"\\\"\",\"609\":\",\",\"610\":\"\\\"\",\"611\":\"6\",\"612\":\"5\",\"613\":\"\\\"\",\"614\":\":\",\"615\":\"\\\"\",\"616\":\",\",\"617\":\"\\\"\",\"618\":\",\",\"619\":\"\\\"\",\"620\":\"6\",\"621\":\"6\",\"622\":\"\\\"\",\"623\":\":\",\"624\":\"\\\"\",\"625\":\"\\\\\",\"626\":\"\\\"\",\"627\":\"\\\"\",\"628\":\",\",\"629\":\"\\\"\",\"630\":\"6\",\"631\":\"7\",\"632\":\"\\\"\",\"633\":\":\",\"634\":\"\\\"\",\"635\":\"8\",\"636\":\"\\\"\",\"637\":\",\",\"638\":\"\\\"\",\"639\":\"6\",\"640\":\"8\",\"641\":\"\\\"\",\"642\":\":\",\"643\":\"\\\"\",\"644\":\"\\\\\",\"645\":\"\\\"\",\"646\":\"\\\"\",\"647\":\",\",\"648\":\"\\\"\",\"649\":\"6\",\"650\":\"9\",\"651\":\"\\\"\",\"652\":\":\",\"653\":\"\\\"\",\"654\":\":\",\"655\":\"\\\"\",\"656\":\",\",\"657\":\"\\\"\",\"658\":\"7\",\"659\":\"0\",\"660\":\"\\\"\",\"661\":\":\",\"662\":\"\\\"\",\"663\":\"\\\\\",\"664\":\"\\\"\",\"665\":\"\\\"\",\"666\":\",\",\"667\":\"\\\"\",\"668\":\"7\",\"669\":\"1\",\"670\":\"\\\"\",\"671\":\":\",\"672\":\"\\\"\",\"673\":\"n\",\"674\":\"\\\"\",\"675\":\",\",\"676\":\"\\\"\",\"677\":\"7\",\"678\":\"2\",\"679\":\"\\\"\",\"680\":\":\",\"681\":\"\\\"\",\"682\":\"\\\\\",\"683\":\"\\\"\",\"684\":\"\\\"\",\"685\":\",\",\"686\":\"\\\"\",\"687\":\"7\",\"688\":\"3\",\"689\":\"\\\"\",\"690\":\":\",\"691\":\"\\\"\",\"692\":\",\",\"693\":\"\\\"\",\"694\":\",\",\"695\":\"\\\"\",\"696\":\"7\",\"697\":\"4\",\"698\":\"\\\"\",\"699\":\":\",\"700\":\"\\\"\",\"701\":\"\\\\\",\"702\":\"\\\"\",\"703\":\"\\\"\",\"704\":\",\",\"705\":\"\\\"\",\"706\":\"7\",\"707\":\"5\",\"708\":\"\\\"\",\"709\":\":\",\"710\":\"\\\"\",\"711\":\"9\",\"712\":\"\\\"\",\"713\":\",\",\"714\":\"\\\"\",\"715\":\"7\",\"716\":\"6\",\"717\":\"\\\"\",\"718\":\":\",\"719\":\"\\\"\",\"720\":\"\\\\\",\"721\":\"\\\"\",\"722\":\"\\\"\",\"723\":\",\",\"724\":\"\\\"\",\"725\":\"7\",\"726\":\"7\",\"727\":\"\\\"\",\"728\":\":\",\"729\":\"\\\"\",\"730\":\":\",\"731\":\"\\\"\",\"732\":\",\",\"733\":\"\\\"\",\"734\":\"7\",\"735\":\"8\",\"736\":\"\\\"\",\"737\":\":\",\"738\":\"\\\"\",\"739\":\"\\\\\",\"740\":\"\\\"\",\"741\":\"\\\"\",\"742\":\",\",\"743\":\"\\\"\",\"744\":\"7\",\"745\":\"9\",\"746\":\"\\\"\",\"747\":\":\",\"748\":\"\\\"\",\"749\":\"e\",\"750\":\"\\\"\",\"751\":\",\",\"752\":\"\\\"\",\"753\":\"8\",\"754\":\"0\",\"755\":\"\\\"\",\"756\":\":\",\"757\":\"\\\"\",\"758\":\"\\\\\",\"759\":\"\\\"\",\"760\":\"\\\"\",\"761\":\",\",\"762\":\"\\\"\",\"763\":\"8\",\"764\":\"1\",\"765\":\"\\\"\",\"766\":\":\",\"767\":\"\\\"\",\"768\":\",\",\"769\":\"\\\"\",\"770\":\",\",\"771\":\"\\\"\",\"772\":\"8\",\"773\":\"2\",\"774\":\"\\\"\",\"775\":\":\",\"776\":\"\\\"\",\"777\":\"\\\\\",\"778\":\"\\\"\",\"779\":\"\\\"\",\"780\":\",\",\"781\":\"\\\"\",\"782\":\"8\",\"783\":\"3\",\"784\":\"\\\"\",\"785\":\":\",\"786\":\"\\\"\",\"787\":\"1\",\"788\":\"\\\"\",\"789\":\",\",\"790\":\"\\\"\",\"791\":\"8\",\"792\":\"4\",\"793\":\"\\\"\",\"794\":\":\",\"795\":\"\\\"\",\"796\":\"0\",\"797\":\"\\\"\",\"798\":\",\",\"799\":\"\\\"\",\"800\":\"8\",\"801\":\"5\",\"802\":\"\\\"\",\"803\":\":\",\"804\":\"\\\"\",\"805\":\"\\\\\",\"806\":\"\\\"\",\"807\":\"\\\"\",\"808\":\",\",\"809\":\"\\\"\",\"810\":\"8\",\"811\":\"6\",\"812\":\"\\\"\",\"813\":\":\",\"814\":\"\\\"\",\"815\":\":\",\"816\":\"\\\"\",\"817\":\",\",\"818\":\"\\\"\",\"819\":\"8\",\"820\":\"7\",\"821\":\"\\\"\",\"822\":\":\",\"823\":\"\\\"\",\"824\":\"\\\\\",\"825\":\"\\\"\",\"826\":\"\\\"\",\"827\":\",\",\"828\":\"\\\"\",\"829\":\"8\",\"830\":\"8\",\"831\":\"\\\"\",\"832\":\":\",\"833\":\"\\\"\",\"834\":\"\\\\\",\"835\":\"\\\\\",\"836\":\"\\\"\",\"837\":\",\",\"838\":\"\\\"\",\"839\":\"8\",\"840\":\"9\",\"841\":\"\\\"\",\"842\":\":\",\"843\":\"\\\"\",\"844\":\"\\\\\",\"845\":\"\\\"\",\"846\":\"\\\"\",\"847\":\",\",\"848\":\"\\\"\",\"849\":\"9\",\"850\":\"0\",\"851\":\"\\\"\",\"852\":\":\",\"853\":\"\\\"\",\"854\":\"\\\\\",\"855\":\"\\\"\",\"856\":\"\\\"\",\"857\":\",\",\"858\":\"\\\"\",\"859\":\"9\",\"860\":\"1\",\"861\":\"\\\"\",\"862\":\":\",\"863\":\"\\\"\",\"864\":\",\",\"865\":\"\\\"\",\"866\":\",\",\"867\":\"\\\"\",\"868\":\"9\",\"869\":\"2\",\"870\":\"\\\"\",\"871\":\":\",\"872\":\"\\\"\",\"873\":\"\\\\\",\"874\":\"\\\"\",\"875\":\"\\\"\",\"876\":\",\",\"877\":\"\\\"\",\"878\":\"9\",\"879\":\"3\",\"880\":\"\\\"\",\"881\":\":\",\"882\":\"\\\"\",\"883\":\"1\",\"884\":\"\\\"\",\"885\":\",\",\"886\":\"\\\"\",\"887\":\"9\",\"888\":\"4\",\"889\":\"\\\"\",\"890\":\":\",\"891\":\"\\\"\",\"892\":\"1\",\"893\":\"\\\"\",\"894\":\",\",\"895\":\"\\\"\",\"896\":\"9\",\"897\":\"5\",\"898\":\"\\\"\",\"899\":\":\",\"900\":\"\\\"\",\"901\":\"\\\\\",\"902\":\"\\\"\",\"903\":\"\\\"\",\"904\":\",\",\"905\":\"\\\"\",\"906\":\"9\",\"907\":\"6\",\"908\":\"\\\"\",\"909\":\":\",\"910\":\"\\\"\",\"911\":\":\",\"912\":\"\\\"\",\"913\":\",\",\"914\":\"\\\"\",\"915\":\"9\",\"916\":\"7\",\"917\":\"\\\"\",\"918\":\":\",\"919\":\"\\\"\",\"920\":\"\\\\\",\"921\":\"\\\"\",\"922\":\"\\\"\",\"923\":\",\",\"924\":\"\\\"\",\"925\":\"9\",\"926\":\"8\",\"927\":\"\\\"\",\"928\":\":\",\"929\":\"\\\"\",\"930\":\":\",\"931\":\"\\\"\",\"932\":\",\",\"933\":\"\\\"\",\"934\":\"9\",\"935\":\"9\",\"936\":\"\\\"\",\"937\":\":\",\"938\":\"\\\"\",\"939\":\"\\\\\",\"940\":\"\\\"\",\"941\":\"\\\"\",\"942\":\",\",\"943\":\"\\\"\",\"944\":\"1\",\"945\":\"0\",\"946\":\"0\",\"947\":\"\\\"\",\"948\":\":\",\"949\":\"\\\"\",\"950\":\",\",\"951\":\"\\\"\",\"952\":\",\",\"953\":\"\\\"\",\"954\":\"1\",\"955\":\"0\",\"956\":\"1\",\"957\":\"\\\"\",\"958\":\":\",\"959\":\"\\\"\",\"960\":\"\\\\\",\"961\":\"\\\"\",\"962\":\"\\\"\",\"963\":\",\",\"964\":\"\\\"\",\"965\":\"1\",\"966\":\"0\",\"967\":\"2\",\"968\":\"\\\"\",\"969\":\":\",\"970\":\"\\\"\",\"971\":\"1\",\"972\":\"\\\"\",\"973\":\",\",\"974\":\"\\\"\",\"975\":\"1\",\"976\":\"0\",\"977\":\"3\",\"978\":\"\\\"\",\"979\":\":\",\"980\":\"\\\"\",\"981\":\"2\",\"982\":\"\\\"\",\"983\":\",\",\"984\":\"\\\"\",\"985\":\"1\",\"986\":\"0\",\"987\":\"4\",\"988\":\"\\\"\",\"989\":\":\",\"990\":\"\\\"\",\"991\":\"\\\\\",\"992\":\"\\\"\",\"993\":\"\\\"\",\"994\":\",\",\"995\":\"\\\"\",\"996\":\"1\",\"997\":\"0\",\"998\":\"5\",\"999\":\"\\\"\",\"1000\":\":\",\"1001\":\"\\\"\",\"1002\":\":\",\"1003\":\"\\\"\",\"1004\":\",\",\"1005\":\"\\\"\",\"1006\":\"1\",\"1007\":\"0\",\"1008\":\"6\",\"1009\":\"\\\"\",\"1010\":\":\",\"1011\":\"\\\"\",\"1012\":\"\\\\\",\"1013\":\"\\\"\",\"1014\":\"\\\"\",\"1015\":\",\",\"1016\":\"\\\"\",\"1017\":\"1\",\"1018\":\"0\",\"1019\":\"7\",\"1020\":\"\\\"\",\"1021\":\":\",\"1022\":\"\\\"\",\"1023\":\"\\\\\",\"1024\":\"\\\\\",\"1025\":\"\\\"\",\"1026\":\",\",\"1027\":\"\\\"\",\"1028\":\"1\",\"1029\":\"0\",\"1030\":\"8\",\"1031\":\"\\\"\",\"1032\":\":\",\"1033\":\"\\\"\",\"1034\":\"\\\\\",\"1035\":\"\\\"\",\"1036\":\"\\\"\",\"1037\":\",\",\"1038\":\"\\\"\",\"1039\":\"1\",\"1040\":\"0\",\"1041\":\"9\",\"1042\":\"\\\"\",\"1043\":\":\",\"1044\":\"\\\"\",\"1045\":\"\\\\\",\"1046\":\"\\\"\",\"1047\":\"\\\"\",\"1048\":\",\",\"1049\":\"\\\"\",\"1050\":\"1\",\"1051\":\"1\",\"1052\":\"0\",\"1053\":\"\\\"\",\"1054\":\":\",\"1055\":\"\\\"\",\"1056\":\",\",\"1057\":\"\\\"\",\"1058\":\",\",\"1059\":\"\\\"\",\"1060\":\"1\",\"1061\":\"1\",\"1062\":\"1\",\"1063\":\"\\\"\",\"1064\":\":\",\"1065\":\"\\\"\",\"1066\":\"\\\\\",\"1067\":\"\\\"\",\"1068\":\"\\\"\",\"1069\":\",\",\"1070\":\"\\\"\",\"1071\":\"1\",\"1072\":\"1\",\"1073\":\"2\",\"1074\":\"\\\"\",\"1075\":\":\",\"1076\":\"\\\"\",\"1077\":\"1\",\"1078\":\"\\\"\",\"1079\":\",\",\"1080\":\"\\\"\",\"1081\":\"1\",\"1082\":\"1\",\"1083\":\"3\",\"1084\":\"\\\"\",\"1085\":\":\",\"1086\":\"\\\"\",\"1087\":\"3\",\"1088\":\"\\\"\",\"1089\":\",\",\"1090\":\"\\\"\",\"1091\":\"1\",\"1092\":\"1\",\"1093\":\"4\",\"1094\":\"\\\"\",\"1095\":\":\",\"1096\":\"\\\"\",\"1097\":\"\\\\\",\"1098\":\"\\\"\",\"1099\":\"\\\"\",\"1100\":\",\",\"1101\":\"\\\"\",\"1102\":\"1\",\"1103\":\"1\",\"1104\":\"5\",\"1105\":\"\\\"\",\"1106\":\":\",\"1107\":\"\\\"\",\"1108\":\":\",\"1109\":\"\\\"\",\"1110\":\",\",\"1111\":\"\\\"\",\"1112\":\"1\",\"1113\":\"1\",\"1114\":\"6\",\"1115\":\"\\\"\",\"1116\":\":\",\"1117\":\"\\\"\",\"1118\":\"\\\\\",\"1119\":\"\\\"\",\"1120\":\"\\\"\",\"1121\":\",\",\"1122\":\"\\\"\",\"1123\":\"1\",\"1124\":\"1\",\"1125\":\"7\",\"1126\":\"\\\"\",\"1127\":\":\",\"1128\":\"\\\"\",\"1129\":\"A\",\"1130\":\"\\\"\",\"1131\":\",\",\"1132\":\"\\\"\",\"1133\":\"1\",\"1134\":\"1\",\"1135\":\"8\",\"1136\":\"\\\"\",\"1137\":\":\",\"1138\":\"\\\"\",\"1139\":\"\\\\\",\"1140\":\"\\\"\",\"1141\":\"\\\"\",\"1142\":\",\",\"1143\":\"\\\"\",\"1144\":\"1\",\"1145\":\"1\",\"1146\":\"9\",\"1147\":\"\\\"\",\"1148\":\":\",\"1149\":\"\\\"\",\"1150\":\",\",\"1151\":\"\\\"\",\"1152\":\",\",\"1153\":\"\\\"\",\"1154\":\"1\",\"1155\":\"2\",\"1156\":\"0\",\"1157\":\"\\\"\",\"1158\":\":\",\"1159\":\"\\\"\",\"1160\":\"\\\\\",\"1161\":\"\\\"\",\"1162\":\"\\\"\",\"1163\":\",\",\"1164\":\"\\\"\",\"1165\":\"1\",\"1166\":\"2\",\"1167\":\"1\",\"1168\":\"\\\"\",\"1169\":\":\",\"1170\":\"\\\"\",\"1171\":\"1\",\"1172\":\"\\\"\",\"1173\":\",\",\"1174\":\"\\\"\",\"1175\":\"1\",\"1176\":\"2\",\"1177\":\"2\",\"1178\":\"\\\"\",\"1179\":\":\",\"1180\":\"\\\"\",\"1181\":\"4\",\"1182\":\"\\\"\",\"1183\":\",\",\"1184\":\"\\\"\",\"1185\":\"1\",\"1186\":\"2\",\"1187\":\"3\",\"1188\":\"\\\"\",\"1189\":\":\",\"1190\":\"\\\"\",\"1191\":\"\\\\\",\"1192\":\"\\\"\",\"1193\":\"\\\"\",\"1194\":\",\",\"1195\":\"\\\"\",\"1196\":\"1\",\"1197\":\"2\",\"1198\":\"4\",\"1199\":\"\\\"\",\"1200\":\":\",\"1201\":\"\\\"\",\"1202\":\":\",\"1203\":\"\\\"\",\"1204\":\",\",\"1205\":\"\\\"\",\"1206\":\"1\",\"1207\":\"2\",\"1208\":\"5\",\"1209\":\"\\\"\",\"1210\":\":\",\"1211\":\"\\\"\",\"1212\":\"\\\\\",\"1213\":\"\\\"\",\"1214\":\"\\\"\",\"1215\":\",\",\"1216\":\"\\\"\",\"1217\":\"1\",\"1218\":\"2\",\"1219\":\"6\",\"1220\":\"\\\"\",\"1221\":\":\",\"1222\":\"\\\"\",\"1223\":\"s\",\"1224\":\"\\\"\",\"1225\":\",\",\"1226\":\"\\\"\",\"1227\":\"1\",\"1228\":\"2\",\"1229\":\"7\",\"1230\":\"\\\"\",\"1231\":\":\",\"1232\":\"\\\"\",\"1233\":\"\\\\\",\"1234\":\"\\\"\",\"1235\":\"\\\"\",\"1236\":\",\",\"1237\":\"\\\"\",\"1238\":\"1\",\"1239\":\"2\",\"1240\":\"8\",\"1241\":\"\\\"\",\"1242\":\":\",\"1243\":\"\\\"\",\"1244\":\",\",\"1245\":\"\\\"\",\"1246\":\",\",\"1247\":\"\\\"\",\"1248\":\"1\",\"1249\":\"2\",\"1250\":\"9\",\"1251\":\"\\\"\",\"1252\":\":\",\"1253\":\"\\\"\",\"1254\":\"\\\\\",\"1255\":\"\\\"\",\"1256\":\"\\\"\",\"1257\":\",\",\"1258\":\"\\\"\",\"1259\":\"1\",\"1260\":\"3\",\"1261\":\"0\",\"1262\":\"\\\"\",\"1263\":\":\",\"1264\":\"\\\"\",\"1265\":\"1\",\"1266\":\"\\\"\",\"1267\":\",\",\"1268\":\"\\\"\",\"1269\":\"1\",\"1270\":\"3\",\"1271\":\"1\",\"1272\":\"\\\"\",\"1273\":\":\",\"1274\":\"\\\"\",\"1275\":\"5\",\"1276\":\"\\\"\",\"1277\":\",\",\"1278\":\"\\\"\",\"1279\":\"1\",\"1280\":\"3\",\"1281\":\"2\",\"1282\":\"\\\"\",\"1283\":\":\",\"1284\":\"\\\"\",\"1285\":\"\\\\\",\"1286\":\"\\\"\",\"1287\":\"\\\"\",\"1288\":\",\",\"1289\":\"\\\"\",\"1290\":\"1\",\"1291\":\"3\",\"1292\":\"3\",\"1293\":\"\\\"\",\"1294\":\":\",\"1295\":\"\\\"\",\"1296\":\":\",\"1297\":\"\\\"\",\"1298\":\",\",\"1299\":\"\\\"\",\"1300\":\"1\",\"1301\":\"3\",\"1302\":\"4\",\"1303\":\"\\\"\",\"1304\":\":\",\"1305\":\"\\\"\",\"1306\":\"\\\\\",\"1307\":\"\\\"\",\"1308\":\"\\\"\",\"1309\":\",\",\"1310\":\"\\\"\",\"1311\":\"1\",\"1312\":\"3\",\"1313\":\"5\",\"1314\":\"\\\"\",\"1315\":\":\",\"1316\":\"\\\"\",\"1317\":\"i\",\"1318\":\"\\\"\",\"1319\":\",\",\"1320\":\"\\\"\",\"1321\":\"1\",\"1322\":\"3\",\"1323\":\"6\",\"1324\":\"\\\"\",\"1325\":\":\",\"1326\":\"\\\"\",\"1327\":\"\\\\\",\"1328\":\"\\\"\",\"1329\":\"\\\"\",\"1330\":\",\",\"1331\":\"\\\"\",\"1332\":\"1\",\"1333\":\"3\",\"1334\":\"7\",\"1335\":\"\\\"\",\"1336\":\":\",\"1337\":\"\\\"\",\"1338\":\",\",\"1339\":\"\\\"\",\"1340\":\",\",\"1341\":\"\\\"\",\"1342\":\"1\",\"1343\":\"3\",\"1344\":\"8\",\"1345\":\"\\\"\",\"1346\":\":\",\"1347\":\"\\\"\",\"1348\":\"\\\\\",\"1349\":\"\\\"\",\"1350\":\"\\\"\",\"1351\":\",\",\"1352\":\"\\\"\",\"1353\":\"1\",\"1354\":\"3\",\"1355\":\"9\",\"1356\":\"\\\"\",\"1357\":\":\",\"1358\":\"\\\"\",\"1359\":\"1\",\"1360\":\"\\\"\",\"1361\":\",\",\"1362\":\"\\\"\",\"1363\":\"1\",\"1364\":\"4\",\"1365\":\"0\",\"1366\":\"\\\"\",\"1367\":\":\",\"1368\":\"\\\"\",\"1369\":\"6\",\"1370\":\"\\\"\",\"1371\":\",\",\"1372\":\"\\\"\",\"1373\":\"1\",\"1374\":\"4\",\"1375\":\"1\",\"1376\":\"\\\"\",\"1377\":\":\",\"1378\":\"\\\"\",\"1379\":\"\\\\\",\"1380\":\"\\\"\",\"1381\":\"\\\"\",\"1382\":\",\",\"1383\":\"\\\"\",\"1384\":\"1\",\"1385\":\"4\",\"1386\":\"2\",\"1387\":\"\\\"\",\"1388\":\":\",\"1389\":\"\\\"\",\"1390\":\":\",\"1391\":\"\\\"\",\"1392\":\",\",\"1393\":\"\\\"\",\"1394\":\"1\",\"1395\":\"4\",\"1396\":\"3\",\"1397\":\"\\\"\",\"1398\":\":\",\"1399\":\"\\\"\",\"1400\":\"\\\\\",\"1401\":\"\\\"\",\"1402\":\"\\\"\",\"1403\":\",\",\"1404\":\"\\\"\",\"1405\":\"1\",\"1406\":\"4\",\"1407\":\"4\",\"1408\":\"\\\"\",\"1409\":\":\",\"1410\":\"\\\"\",\"1411\":\"a\",\"1412\":\"\\\"\",\"1413\":\",\",\"1414\":\"\\\"\",\"1415\":\"1\",\"1416\":\"4\",\"1417\":\"5\",\"1418\":\"\\\"\",\"1419\":\":\",\"1420\":\"\\\"\",\"1421\":\"\\\\\",\"1422\":\"\\\"\",\"1423\":\"\\\"\",\"1424\":\",\",\"1425\":\"\\\"\",\"1426\":\"1\",\"1427\":\"4\",\"1428\":\"6\",\"1429\":\"\\\"\",\"1430\":\":\",\"1431\":\"\\\"\",\"1432\":\",\",\"1433\":\"\\\"\",\"1434\":\",\",\"1435\":\"\\\"\",\"1436\":\"1\",\"1437\":\"4\",\"1438\":\"7\",\"1439\":\"\\\"\",\"1440\":\":\",\"1441\":\"\\\"\",\"1442\":\"\\\\\",\"1443\":\"\\\"\",\"1444\":\"\\\"\",\"1445\":\",\",\"1446\":\"\\\"\",\"1447\":\"1\",\"1448\":\"4\",\"1449\":\"8\",\"1450\":\"\\\"\",\"1451\":\":\",\"1452\":\"\\\"\",\"1453\":\"1\",\"1454\":\"\\\"\",\"1455\":\",\",\"1456\":\"\\\"\",\"1457\":\"1\",\"1458\":\"4\",\"1459\":\"9\",\"1460\":\"\\\"\",\"1461\":\":\",\"1462\":\"\\\"\",\"1463\":\"7\",\"1464\":\"\\\"\",\"1465\":\",\",\"1466\":\"\\\"\",\"1467\":\"1\",\"1468\":\"5\",\"1469\":\"0\",\"1470\":\"\\\"\",\"1471\":\":\",\"1472\":\"\\\"\",\"1473\":\"\\\\\",\"1474\":\"\\\"\",\"1475\":\"\\\"\",\"1476\":\",\",\"1477\":\"\\\"\",\"1478\":\"1\",\"1479\":\"5\",\"1480\":\"1\",\"1481\":\"\\\"\",\"1482\":\":\",\"1483\":\"\\\"\",\"1484\":\":\",\"1485\":\"\\\"\",\"1486\":\",\",\"1487\":\"\\\"\",\"1488\":\"1\",\"1489\":\"5\",\"1490\":\"2\",\"1491\":\"\\\"\",\"1492\":\":\",\"1493\":\"\\\"\",\"1494\":\"\\\\\",\"1495\":\"\\\"\",\"1496\":\"\\\"\",\"1497\":\",\",\"1498\":\"\\\"\",\"1499\":\"1\",\"1500\":\"5\",\"1501\":\"3\",\"1502\":\"\\\"\",\"1503\":\":\",\"1504\":\"\\\"\",\"1505\":\"/\",\"1506\":\"\\\"\",\"1507\":\",\",\"1508\":\"\\\"\",\"1509\":\"1\",\"1510\":\"5\",\"1511\":\"4\",\"1512\":\"\\\"\",\"1513\":\":\",\"1514\":\"\\\"\",\"1515\":\"\\\\\",\"1516\":\"\\\"\",\"1517\":\"\\\"\",\"1518\":\",\",\"1519\":\"\\\"\",\"1520\":\"1\",\"1521\":\"5\",\"1522\":\"5\",\"1523\":\"\\\"\",\"1524\":\":\",\"1525\":\"\\\"\",\"1526\":\",\",\"1527\":\"\\\"\",\"1528\":\",\",\"1529\":\"\\\"\",\"1530\":\"1\",\"1531\":\"5\",\"1532\":\"6\",\"1533\":\"\\\"\",\"1534\":\":\",\"1535\":\"\\\"\",\"1536\":\"\\\\\",\"1537\":\"\\\"\",\"1538\":\"\\\"\",\"1539\":\",\",\"1540\":\"\\\"\",\"1541\":\"1\",\"1542\":\"5\",\"1543\":\"7\",\"1544\":\"\\\"\",\"1545\":\":\",\"1546\":\"\\\"\",\"1547\":\"1\",\"1548\":\"\\\"\",\"1549\":\",\",\"1550\":\"\\\"\",\"1551\":\"1\",\"1552\":\"5\",\"1553\":\"8\",\"1554\":\"\\\"\",\"1555\":\":\",\"1556\":\"\\\"\",\"1557\":\"8\",\"1558\":\"\\\"\",\"1559\":\",\",\"1560\":\"\\\"\",\"1561\":\"1\",\"1562\":\"5\",\"1563\":\"9\",\"1564\":\"\\\"\",\"1565\":\":\",\"1566\":\"\\\"\",\"1567\":\"\\\\\",\"1568\":\"\\\"\",\"1569\":\"\\\"\",\"1570\":\",\",\"1571\":\"\\\"\",\"1572\":\"1\",\"1573\":\"6\",\"1574\":\"0\",\"1575\":\"\\\"\",\"1576\":\":\",\"1577\":\"\\\"\",\"1578\":\":\",\"1579\":\"\\\"\",\"1580\":\",\",\"1581\":\"\\\"\",\"1582\":\"1\",\"1583\":\"6\",\"1584\":\"1\",\"1585\":\"\\\"\",\"1586\":\":\",\"1587\":\"\\\"\",\"1588\":\"\\\\\",\"1589\":\"\\\"\",\"1590\":\"\\\"\",\"1591\":\",\",\"1592\":\"\\\"\",\"1593\":\"1\",\"1594\":\"6\",\"1595\":\"2\",\"1596\":\"\\\"\",\"1597\":\":\",\"1598\":\"\\\"\",\"1599\":\"K\",\"1600\":\"\\\"\",\"1601\":\",\",\"1602\":\"\\\"\",\"1603\":\"1\",\"1604\":\"6\",\"1605\":\"3\",\"1606\":\"\\\"\",\"1607\":\":\",\"1608\":\"\\\"\",\"1609\":\"\\\\\",\"1610\":\"\\\"\",\"1611\":\"\\\"\",\"1612\":\",\",\"1613\":\"\\\"\",\"1614\":\"1\",\"1615\":\"6\",\"1616\":\"4\",\"1617\":\"\\\"\",\"1618\":\":\",\"1619\":\"\\\"\",\"1620\":\",\",\"1621\":\"\\\"\",\"1622\":\",\",\"1623\":\"\\\"\",\"1624\":\"1\",\"1625\":\"6\",\"1626\":\"5\",\"1627\":\"\\\"\",\"1628\":\":\",\"1629\":\"\\\"\",\"1630\":\"\\\\\",\"1631\":\"\\\"\",\"1632\":\"\\\"\",\"1633\":\",\",\"1634\":\"\\\"\",\"1635\":\"1\",\"1636\":\"6\",\"1637\":\"6\",\"1638\":\"\\\"\",\"1639\":\":\",\"1640\":\"\\\"\",\"1641\":\"1\",\"1642\":\"\\\"\",\"1643\":\",\",\"1644\":\"\\\"\",\"1645\":\"1\",\"1646\":\"6\",\"1647\":\"7\",\"1648\":\"\\\"\",\"1649\":\":\",\"1650\":\"\\\"\",\"1651\":\"9\",\"1652\":\"\\\"\",\"1653\":\",\",\"1654\":\"\\\"\",\"1655\":\"1\",\"1656\":\"6\",\"1657\":\"8\",\"1658\":\"\\\"\",\"1659\":\":\",\"1660\":\"\\\"\",\"1661\":\"\\\\\",\"1662\":\"\\\"\",\"1663\":\"\\\"\",\"1664\":\",\",\"1665\":\"\\\"\",\"1666\":\"1\",\"1667\":\"6\",\"1668\":\"9\",\"1669\":\"\\\"\",\"1670\":\":\",\"1671\":\"\\\"\",\"1672\":\":\",\"1673\":\"\\\"\",\"1674\":\",\",\"1675\":\"\\\"\",\"1676\":\"1\",\"1677\":\"7\",\"1678\":\"0\",\"1679\":\"\\\"\",\"1680\":\":\",\"1681\":\"\\\"\",\"1682\":\"\\\\\",\"1683\":\"\\\"\",\"1684\":\"\\\"\",\"1685\":\",\",\"1686\":\"\\\"\",\"1687\":\"1\",\"1688\":\"7\",\"1689\":\"1\",\"1690\":\"\\\"\",\"1691\":\":\",\"1692\":\"\\\"\",\"1693\":\"o\",\"1694\":\"\\\"\",\"1695\":\",\",\"1696\":\"\\\"\",\"1697\":\"1\",\"1698\":\"7\",\"1699\":\"2\",\"1700\":\"\\\"\",\"1701\":\":\",\"1702\":\"\\\"\",\"1703\":\"\\\\\",\"1704\":\"\\\"\",\"1705\":\"\\\"\",\"1706\":\",\",\"1707\":\"\\\"\",\"1708\":\"1\",\"1709\":\"7\",\"1710\":\"3\",\"1711\":\"\\\"\",\"1712\":\":\",\"1713\":\"\\\"\",\"1714\":\",\",\"1715\":\"\\\"\",\"1716\":\",\",\"1717\":\"\\\"\",\"1718\":\"1\",\"1719\":\"7\",\"1720\":\"4\",\"1721\":\"\\\"\",\"1722\":\":\",\"1723\":\"\\\"\",\"1724\":\"\\\\\",\"1725\":\"\\\"\",\"1726\":\"\\\"\",\"1727\":\",\",\"1728\":\"\\\"\",\"1729\":\"1\",\"1730\":\"7\",\"1731\":\"5\",\"1732\":\"\\\"\",\"1733\":\":\",\"1734\":\"\\\"\",\"1735\":\"2\",\"1736\":\"\\\"\",\"1737\":\",\",\"1738\":\"\\\"\",\"1739\":\"1\",\"1740\":\"7\",\"1741\":\"6\",\"1742\":\"\\\"\",\"1743\":\":\",\"1744\":\"\\\"\",\"1745\":\"0\",\"1746\":\"\\\"\",\"1747\":\",\",\"1748\":\"\\\"\",\"1749\":\"1\",\"1750\":\"7\",\"1751\":\"7\",\"1752\":\"\\\"\",\"1753\":\":\",\"1754\":\"\\\"\",\"1755\":\"\\\\\",\"1756\":\"\\\"\",\"1757\":\"\\\"\",\"1758\":\",\",\"1759\":\"\\\"\",\"1760\":\"1\",\"1761\":\"7\",\"1762\":\"8\",\"1763\":\"\\\"\",\"1764\":\":\",\"1765\":\"\\\"\",\"1766\":\":\",\"1767\":\"\\\"\",\"1768\":\",\",\"1769\":\"\\\"\",\"1770\":\"1\",\"1771\":\"7\",\"1772\":\"9\",\"1773\":\"\\\"\",\"1774\":\":\",\"1775\":\"\\\"\",\"1776\":\"\\\\\",\"1777\":\"\\\"\",\"1778\":\"\\\"\",\"1779\":\",\",\"1780\":\"\\\"\",\"1781\":\"1\",\"1782\":\"8\",\"1783\":\"0\",\"1784\":\"\\\"\",\"1785\":\":\",\"1786\":\"\\\"\",\"1787\":\"l\",\"1788\":\"\\\"\",\"1789\":\",\",\"1790\":\"\\\"\",\"1791\":\"1\",\"1792\":\"8\",\"1793\":\"1\",\"1794\":\"\\\"\",\"1795\":\":\",\"1796\":\"\\\"\",\"1797\":\"\\\\\",\"1798\":\"\\\"\",\"1799\":\"\\\"\",\"1800\":\",\",\"1801\":\"\\\"\",\"1802\":\"1\",\"1803\":\"8\",\"1804\":\"2\",\"1805\":\"\\\"\",\"1806\":\":\",\"1807\":\"\\\"\",\"1808\":\",\",\"1809\":\"\\\"\",\"1810\":\",\",\"1811\":\"\\\"\",\"1812\":\"1\",\"1813\":\"8\",\"1814\":\"3\",\"1815\":\"\\\"\",\"1816\":\":\",\"1817\":\"\\\"\",\"1818\":\"\\\\\",\"1819\":\"\\\"\",\"1820\":\"\\\"\",\"1821\":\",\",\"1822\":\"\\\"\",\"1823\":\"1\",\"1824\":\"8\",\"1825\":\"4\",\"1826\":\"\\\"\",\"1827\":\":\",\"1828\":\"\\\"\",\"1829\":\"2\",\"1830\":\"\\\"\",\"1831\":\",\",\"1832\":\"\\\"\",\"1833\":\"1\",\"1834\":\"8\",\"1835\":\"5\",\"1836\":\"\\\"\",\"1837\":\":\",\"1838\":\"\\\"\",\"1839\":\"1\",\"1840\":\"\\\"\",\"1841\":\",\",\"1842\":\"\\\"\",\"1843\":\"1\",\"1844\":\"8\",\"1845\":\"6\",\"1846\":\"\\\"\",\"1847\":\":\",\"1848\":\"\\\"\",\"1849\":\"\\\\\",\"1850\":\"\\\"\",\"1851\":\"\\\"\",\"1852\":\",\",\"1853\":\"\\\"\",\"1854\":\"1\",\"1855\":\"8\",\"1856\":\"7\",\"1857\":\"\\\"\",\"1858\":\":\",\"1859\":\"\\\"\",\"1860\":\":\",\"1861\":\"\\\"\",\"1862\":\",\",\"1863\":\"\\\"\",\"1864\":\"1\",\"1865\":\"8\",\"1866\":\"8\",\"1867\":\"\\\"\",\"1868\":\":\",\"1869\":\"\\\"\",\"1870\":\"\\\\\",\"1871\":\"\\\"\",\"1872\":\"\\\"\",\"1873\":\",\",\"1874\":\"\\\"\",\"1875\":\"1\",\"1876\":\"8\",\"1877\":\"9\",\"1878\":\"\\\"\",\"1879\":\":\",\"1880\":\"\\\"\",\"1881\":\"k\",\"1882\":\"\\\"\",\"1883\":\",\",\"1884\":\"\\\"\",\"1885\":\"1\",\"1886\":\"9\",\"1887\":\"0\",\"1888\":\"\\\"\",\"1889\":\":\",\"1890\":\"\\\"\",\"1891\":\"\\\\\",\"1892\":\"\\\"\",\"1893\":\"\\\"\",\"1894\":\",\",\"1895\":\"\\\"\",\"1896\":\"1\",\"1897\":\"9\",\"1898\":\"1\",\"1899\":\"\\\"\",\"1900\":\":\",\"1901\":\"\\\"\",\"1902\":\",\",\"1903\":\"\\\"\",\"1904\":\",\",\"1905\":\"\\\"\",\"1906\":\"1\",\"1907\":\"9\",\"1908\":\"2\",\"1909\":\"\\\"\",\"1910\":\":\",\"1911\":\"\\\"\",\"1912\":\"\\\\\",\"1913\":\"\\\"\",\"1914\":\"\\\"\",\"1915\":\",\",\"1916\":\"\\\"\",\"1917\":\"1\",\"1918\":\"9\",\"1919\":\"3\",\"1920\":\"\\\"\",\"1921\":\":\",\"1922\":\"\\\"\",\"1923\":\"2\",\"1924\":\"\\\"\",\"1925\":\",\",\"1926\":\"\\\"\",\"1927\":\"1\",\"1928\":\"9\",\"1929\":\"4\",\"1930\":\"\\\"\",\"1931\":\":\",\"1932\":\"\\\"\",\"1933\":\"2\",\"1934\":\"\\\"\",\"1935\":\",\",\"1936\":\"\\\"\",\"1937\":\"1\",\"1938\":\"9\",\"1939\":\"5\",\"1940\":\"\\\"\",\"1941\":\":\",\"1942\":\"\\\"\",\"1943\":\"\\\\\",\"1944\":\"\\\"\",\"1945\":\"\\\"\",\"1946\":\",\",\"1947\":\"\\\"\",\"1948\":\"1\",\"1949\":\"9\",\"1950\":\"6\",\"1951\":\"\\\"\",\"1952\":\":\",\"1953\":\"\\\"\",\"1954\":\":\",\"1955\":\"\\\"\",\"1956\":\",\",\"1957\":\"\\\"\",\"1958\":\"1\",\"1959\":\"9\",\"1960\":\"7\",\"1961\":\"\\\"\",\"1962\":\":\",\"1963\":\"\\\"\",\"1964\":\"\\\\\",\"1965\":\"\\\"\",\"1966\":\"\\\"\",\"1967\":\",\",\"1968\":\"\\\"\",\"1969\":\"1\",\"1970\":\"9\",\"1971\":\"8\",\"1972\":\"\\\"\",\"1973\":\":\",\"1974\":\"\\\"\",\"1975\":\"a\",\"1976\":\"\\\"\",\"1977\":\",\",\"1978\":\"\\\"\",\"1979\":\"1\",\"1980\":\"9\",\"1981\":\"9\",\"1982\":\"\\\"\",\"1983\":\":\",\"1984\":\"\\\"\",\"1985\":\"\\\\\",\"1986\":\"\\\"\",\"1987\":\"\\\"\",\"1988\":\",\",\"1989\":\"\\\"\",\"1990\":\"2\",\"1991\":\"0\",\"1992\":\"0\",\"1993\":\"\\\"\",\"1994\":\":\",\"1995\":\"\\\"\",\"1996\":\",\",\"1997\":\"\\\"\",\"1998\":\",\",\"1999\":\"\\\"\",\"2000\":\"2\",\"2001\":\"0\",\"2002\":\"1\",\"2003\":\"\\\"\",\"2004\":\":\",\"2005\":\"\\\"\",\"2006\":\"\\\\\",\"2007\":\"\\\"\",\"2008\":\"\\\"\",\"2009\":\",\",\"2010\":\"\\\"\",\"2011\":\"2\",\"2012\":\"0\",\"2013\":\"2\",\"2014\":\"\\\"\",\"2015\":\":\",\"2016\":\"\\\"\",\"2017\":\"2\",\"2018\":\"\\\"\",\"2019\":\",\",\"2020\":\"\\\"\",\"2021\":\"2\",\"2022\":\"0\",\"2023\":\"3\",\"2024\":\"\\\"\",\"2025\":\":\",\"2026\":\"\\\"\",\"2027\":\"3\",\"2028\":\"\\\"\",\"2029\":\",\",\"2030\":\"\\\"\",\"2031\":\"2\",\"2032\":\"0\",\"2033\":\"4\",\"2034\":\"\\\"\",\"2035\":\":\",\"2036\":\"\\\"\",\"2037\":\"\\\\\",\"2038\":\"\\\"\",\"2039\":\"\\\"\",\"2040\":\",\",\"2041\":\"\\\"\",\"2042\":\"2\",\"2043\":\"0\",\"2044\":\"5\",\"2045\":\"\\\"\",\"2046\":\":\",\"2047\":\"\\\"\",\"2048\":\":\",\"2049\":\"\\\"\",\"2050\":\",\",\"2051\":\"\\\"\",\"2052\":\"2\",\"2053\":\"0\",\"2054\":\"6\",\"2055\":\"\\\"\",\"2056\":\":\",\"2057\":\"\\\"\",\"2058\":\"\\\\\",\"2059\":\"\\\"\",\"2060\":\"\\\"\",\"2061\":\",\",\"2062\":\"\\\"\",\"2063\":\"2\",\"2064\":\"0\",\"2065\":\"7\",\"2066\":\"\\\"\",\"2067\":\":\",\"2068\":\"\\\"\",\"2069\":\"t\",\"2070\":\"\\\"\",\"2071\":\",\",\"2072\":\"\\\"\",\"2073\":\"2\",\"2074\":\"0\",\"2075\":\"8\",\"2076\":\"\\\"\",\"2077\":\":\",\"2078\":\"\\\"\",\"2079\":\"\\\\\",\"2080\":\"\\\"\",\"2081\":\"\\\"\",\"2082\":\",\",\"2083\":\"\\\"\",\"2084\":\"2\",\"2085\":\"0\",\"2086\":\"9\",\"2087\":\"\\\"\",\"2088\":\":\",\"2089\":\"\\\"\",\"2090\":\",\",\"2091\":\"\\\"\",\"2092\":\",\",\"2093\":\"\\\"\",\"2094\":\"2\",\"2095\":\"1\",\"2096\":\"0\",\"2097\":\"\\\"\",\"2098\":\":\",\"2099\":\"\\\"\",\"2100\":\"\\\\\",\"2101\":\"\\\"\",\"2102\":\"\\\"\",\"2103\":\",\",\"2104\":\"\\\"\",\"2105\":\"2\",\"2106\":\"1\",\"2107\":\"1\",\"2108\":\"\\\"\",\"2109\":\":\",\"2110\":\"\\\"\",\"2111\":\"2\",\"2112\":\"\\\"\",\"2113\":\",\",\"2114\":\"\\\"\",\"2115\":\"2\",\"2116\":\"1\",\"2117\":\"2\",\"2118\":\"\\\"\",\"2119\":\":\",\"2120\":\"\\\"\",\"2121\":\"4\",\"2122\":\"\\\"\",\"2123\":\",\",\"2124\":\"\\\"\",\"2125\":\"2\",\"2126\":\"1\",\"2127\":\"3\",\"2128\":\"\\\"\",\"2129\":\":\",\"2130\":\"\\\"\",\"2131\":\"\\\\\",\"2132\":\"\\\"\",\"2133\":\"\\\"\",\"2134\":\",\",\"2135\":\"\\\"\",\"2136\":\"2\",\"2137\":\"1\",\"2138\":\"4\",\"2139\":\"\\\"\",\"2140\":\":\",\"2141\":\"\\\"\",\"2142\":\":\",\"2143\":\"\\\"\",\"2144\":\",\",\"2145\":\"\\\"\",\"2146\":\"2\",\"2147\":\"1\",\"2148\":\"5\",\"2149\":\"\\\"\",\"2150\":\":\",\"2151\":\"\\\"\",\"2152\":\"\\\\\",\"2153\":\"\\\"\",\"2154\":\"\\\"\",\"2155\":\",\",\"2156\":\"\\\"\",\"2157\":\"2\",\"2158\":\"1\",\"2159\":\"6\",\"2160\":\"\\\"\",\"2161\":\":\",\"2162\":\"\\\"\",\"2163\":\"a\",\"2164\":\"\\\"\",\"2165\":\",\",\"2166\":\"\\\"\",\"2167\":\"2\",\"2168\":\"1\",\"2169\":\"7\",\"2170\":\"\\\"\",\"2171\":\":\",\"2172\":\"\\\"\",\"2173\":\"\\\\\",\"2174\":\"\\\"\",\"2175\":\"\\\"\",\"2176\":\",\",\"2177\":\"\\\"\",\"2178\":\"2\",\"2179\":\"1\",\"2180\":\"8\",\"2181\":\"\\\"\",\"2182\":\":\",\"2183\":\"\\\"\",\"2184\":\",\",\"2185\":\"\\\"\",\"2186\":\",\",\"2187\":\"\\\"\",\"2188\":\"2\",\"2189\":\"1\",\"2190\":\"9\",\"2191\":\"\\\"\",\"2192\":\":\",\"2193\":\"\\\"\",\"2194\":\"\\\\\",\"2195\":\"\\\"\",\"2196\":\"\\\"\",\"2197\":\",\",\"2198\":\"\\\"\",\"2199\":\"2\",\"2200\":\"2\",\"2201\":\"0\",\"2202\":\"\\\"\",\"2203\":\":\",\"2204\":\"\\\"\",\"2205\":\"2\",\"2206\":\"\\\"\",\"2207\":\",\",\"2208\":\"\\\"\",\"2209\":\"2\",\"2210\":\"2\",\"2211\":\"1\",\"2212\":\"\\\"\",\"2213\":\":\",\"2214\":\"\\\"\",\"2215\":\"5\",\"2216\":\"\\\"\",\"2217\":\",\",\"2218\":\"\\\"\",\"2219\":\"2\",\"2220\":\"2\",\"2221\":\"2\",\"2222\":\"\\\"\",\"2223\":\":\",\"2224\":\"\\\"\",\"2225\":\"\\\\\",\"2226\":\"\\\"\",\"2227\":\"\\\"\",\"2228\":\",\",\"2229\":\"\\\"\",\"2230\":\"2\",\"2231\":\"2\",\"2232\":\"3\",\"2233\":\"\\\"\",\"2234\":\":\",\"2235\":\"\\\"\",\"2236\":\":\",\"2237\":\"\\\"\",\"2238\":\",\",\"2239\":\"\\\"\",\"2240\":\"2\",\"2241\":\"2\",\"2242\":\"4\",\"2243\":\"\\\"\",\"2244\":\":\",\"2245\":\"\\\"\",\"2246\":\"\\\\\",\"2247\":\"\\\"\",\"2248\":\"\\\"\",\"2249\":\",\",\"2250\":\"\\\"\",\"2251\":\"2\",\"2252\":\"2\",\"2253\":\"5\",\"2254\":\"\\\"\",\"2255\":\":\",\"2256\":\"\\\"\",\"2257\":\"\\\\\",\"2258\":\"\\\\\",\"2259\":\"\\\"\",\"2260\":\",\",\"2261\":\"\\\"\",\"2262\":\"2\",\"2263\":\"2\",\"2264\":\"6\",\"2265\":\"\\\"\",\"2266\":\":\",\"2267\":\"\\\"\",\"2268\":\"\\\\\",\"2269\":\"\\\"\",\"2270\":\"\\\"\",\"2271\":\",\",\"2272\":\"\\\"\",\"2273\":\"2\",\"2274\":\"2\",\"2275\":\"7\",\"2276\":\"\\\"\",\"2277\":\":\",\"2278\":\"\\\"\",\"2279\":\"\\\\\",\"2280\":\"\\\"\",\"2281\":\"\\\"\",\"2282\":\",\",\"2283\":\"\\\"\",\"2284\":\"2\",\"2285\":\"2\",\"2286\":\"8\",\"2287\":\"\\\"\",\"2288\":\":\",\"2289\":\"\\\"\",\"2290\":\",\",\"2291\":\"\\\"\",\"2292\":\",\",\"2293\":\"\\\"\",\"2294\":\"2\",\"2295\":\"2\",\"2296\":\"9\",\"2297\":\"\\\"\",\"2298\":\":\",\"2299\":\"\\\"\",\"2300\":\"\\\\\",\"2301\":\"\\\"\",\"2302\":\"\\\"\",\"2303\":\",\",\"2304\":\"\\\"\",\"2305\":\"2\",\"2306\":\"3\",\"2307\":\"0\",\"2308\":\"\\\"\",\"2309\":\":\",\"2310\":\"\\\"\",\"2311\":\"2\",\"2312\":\"\\\"\",\"2313\":\",\",\"2314\":\"\\\"\",\"2315\":\"2\",\"2316\":\"3\",\"2317\":\"1\",\"2318\":\"\\\"\",\"2319\":\":\",\"2320\":\"\\\"\",\"2321\":\"6\",\"2322\":\"\\\"\",\"2323\":\",\",\"2324\":\"\\\"\",\"2325\":\"2\",\"2326\":\"3\",\"2327\":\"2\",\"2328\":\"\\\"\",\"2329\":\":\",\"2330\":\"\\\"\",\"2331\":\"\\\\\",\"2332\":\"\\\"\",\"2333\":\"\\\"\",\"2334\":\",\",\"2335\":\"\\\"\",\"2336\":\"2\",\"2337\":\"3\",\"2338\":\"3\",\"2339\":\"\\\"\",\"2340\":\":\",\"2341\":\"\\\"\",\"2342\":\":\",\"2343\":\"\\\"\",\"2344\":\",\",\"2345\":\"\\\"\",\"2346\":\"2\",\"2347\":\"3\",\"2348\":\"4\",\"2349\":\"\\\"\",\"2350\":\":\",\"2351\":\"\\\"\",\"2352\":\"\\\\\",\"2353\":\"\\\"\",\"2354\":\"\\\"\",\"2355\":\",\",\"2356\":\"\\\"\",\"2357\":\"2\",\"2358\":\"3\",\"2359\":\"5\",\"2360\":\"\\\"\",\"2361\":\":\",\"2362\":\"\\\"\",\"2363\":\",\",\"2364\":\"\\\"\",\"2365\":\",\",\"2366\":\"\\\"\",\"2367\":\"2\",\"2368\":\"3\",\"2369\":\"6\",\"2370\":\"\\\"\",\"2371\":\":\",\"2372\":\"\\\"\",\"2373\":\"\\\\\",\"2374\":\"\\\"\",\"2375\":\"\\\"\",\"2376\":\",\",\"2377\":\"\\\"\",\"2378\":\"2\",\"2379\":\"3\",\"2380\":\"7\",\"2381\":\"\\\"\",\"2382\":\":\",\"2383\":\"\\\"\",\"2384\":\",\",\"2385\":\"\\\"\",\"2386\":\",\",\"2387\":\"\\\"\",\"2388\":\"2\",\"2389\":\"3\",\"2390\":\"8\",\"2391\":\"\\\"\",\"2392\":\":\",\"2393\":\"\\\"\",\"2394\":\"\\\\\",\"2395\":\"\\\"\",\"2396\":\"\\\"\",\"2397\":\",\",\"2398\":\"\\\"\",\"2399\":\"2\",\"2400\":\"3\",\"2401\":\"9\",\"2402\":\"\\\"\",\"2403\":\":\",\"2404\":\"\\\"\",\"2405\":\"2\",\"2406\":\"\\\"\",\"2407\":\",\",\"2408\":\"\\\"\",\"2409\":\"2\",\"2410\":\"4\",\"2411\":\"0\",\"2412\":\"\\\"\",\"2413\":\":\",\"2414\":\"\\\"\",\"2415\":\"7\",\"2416\":\"\\\"\",\"2417\":\",\",\"2418\":\"\\\"\",\"2419\":\"2\",\"2420\":\"4\",\"2421\":\"1\",\"2422\":\"\\\"\",\"2423\":\":\",\"2424\":\"\\\"\",\"2425\":\"\\\\\",\"2426\":\"\\\"\",\"2427\":\"\\\"\",\"2428\":\",\",\"2429\":\"\\\"\",\"2430\":\"2\",\"2431\":\"4\",\"2432\":\"2\",\"2433\":\"\\\"\",\"2434\":\":\",\"2435\":\"\\\"\",\"2436\":\":\",\"2437\":\"\\\"\",\"2438\":\",\",\"2439\":\"\\\"\",\"2440\":\"2\",\"2441\":\"4\",\"2442\":\"3\",\"2443\":\"\\\"\",\"2444\":\":\",\"2445\":\"\\\"\",\"2446\":\"\\\\\",\"2447\":\"\\\"\",\"2448\":\"\\\"\",\"2449\":\",\",\"2450\":\"\\\"\",\"2451\":\"2\",\"2452\":\"4\",\"2453\":\"4\",\"2454\":\"\\\"\",\"2455\":\":\",\"2456\":\"\\\"\",\"2457\":\"\\\\\",\"2458\":\"\\\\\",\"2459\":\"\\\"\",\"2460\":\",\",\"2461\":\"\\\"\",\"2462\":\"2\",\"2463\":\"4\",\"2464\":\"5\",\"2465\":\"\\\"\",\"2466\":\":\",\"2467\":\"\\\"\",\"2468\":\"\\\\\",\"2469\":\"\\\"\",\"2470\":\"\\\"\",\"2471\":\",\",\"2472\":\"\\\"\",\"2473\":\"2\",\"2474\":\"4\",\"2475\":\"6\",\"2476\":\"\\\"\",\"2477\":\":\",\"2478\":\"\\\"\",\"2479\":\"\\\\\",\"2480\":\"\\\"\",\"2481\":\"\\\"\",\"2482\":\",\",\"2483\":\"\\\"\",\"2484\":\"2\",\"2485\":\"4\",\"2486\":\"7\",\"2487\":\"\\\"\",\"2488\":\":\",\"2489\":\"\\\"\",\"2490\":\",\",\"2491\":\"\\\"\",\"2492\":\",\",\"2493\":\"\\\"\",\"2494\":\"2\",\"2495\":\"4\",\"2496\":\"8\",\"2497\":\"\\\"\",\"2498\":\":\",\"2499\":\"\\\"\",\"2500\":\"\\\\\",\"2501\":\"\\\"\",\"2502\":\"\\\"\",\"2503\":\",\",\"2504\":\"\\\"\",\"2505\":\"2\",\"2506\":\"4\",\"2507\":\"9\",\"2508\":\"\\\"\",\"2509\":\":\",\"2510\":\"\\\"\",\"2511\":\"2\",\"2512\":\"\\\"\",\"2513\":\",\",\"2514\":\"\\\"\",\"2515\":\"2\",\"2516\":\"5\",\"2517\":\"0\",\"2518\":\"\\\"\",\"2519\":\":\",\"2520\":\"\\\"\",\"2521\":\"8\",\"2522\":\"\\\"\",\"2523\":\",\",\"2524\":\"\\\"\",\"2525\":\"2\",\"2526\":\"5\",\"2527\":\"1\",\"2528\":\"\\\"\",\"2529\":\":\",\"2530\":\"\\\"\",\"2531\":\"\\\\\",\"2532\":\"\\\"\",\"2533\":\"\\\"\",\"2534\":\",\",\"2535\":\"\\\"\",\"2536\":\"2\",\"2537\":\"5\",\"2538\":\"2\",\"2539\":\"\\\"\",\"2540\":\":\",\"2541\":\"\\\"\",\"2542\":\":\",\"2543\":\"\\\"\",\"2544\":\",\",\"2545\":\"\\\"\",\"2546\":\"2\",\"2547\":\"5\",\"2548\":\"3\",\"2549\":\"\\\"\",\"2550\":\":\",\"2551\":\"\\\"\",\"2552\":\"\\\\\",\"2553\":\"\\\"\",\"2554\":\"\\\"\",\"2555\":\",\",\"2556\":\"\\\"\",\"2557\":\"2\",\"2558\":\"5\",\"2559\":\"4\",\"2560\":\"\\\"\",\"2561\":\":\",\"2562\":\"\\\"\",\"2563\":\"l\",\"2564\":\"\\\"\",\"2565\":\",\",\"2566\":\"\\\"\",\"2567\":\"2\",\"2568\":\"5\",\"2569\":\"5\",\"2570\":\"\\\"\",\"2571\":\":\",\"2572\":\"\\\"\",\"2573\":\"\\\\\",\"2574\":\"\\\"\",\"2575\":\"\\\"\",\"2576\":\",\",\"2577\":\"\\\"\",\"2578\":\"2\",\"2579\":\"5\",\"2580\":\"6\",\"2581\":\"\\\"\",\"2582\":\":\",\"2583\":\"\\\"\",\"2584\":\",\",\"2585\":\"\\\"\",\"2586\":\",\",\"2587\":\"\\\"\",\"2588\":\"2\",\"2589\":\"5\",\"2590\":\"7\",\"2591\":\"\\\"\",\"2592\":\":\",\"2593\":\"\\\"\",\"2594\":\"\\\\\",\"2595\":\"\\\"\",\"2596\":\"\\\"\",\"2597\":\",\",\"2598\":\"\\\"\",\"2599\":\"2\",\"2600\":\"5\",\"2601\":\"8\",\"2602\":\"\\\"\",\"2603\":\":\",\"2604\":\"\\\"\",\"2605\":\"2\",\"2606\":\"\\\"\",\"2607\":\",\",\"2608\":\"\\\"\",\"2609\":\"2\",\"2610\":\"5\",\"2611\":\"9\",\"2612\":\"\\\"\",\"2613\":\":\",\"2614\":\"\\\"\",\"2615\":\"9\",\"2616\":\"\\\"\",\"2617\":\",\",\"2618\":\"\\\"\",\"2619\":\"2\",\"2620\":\"6\",\"2621\":\"0\",\"2622\":\"\\\"\",\"2623\":\":\",\"2624\":\"\\\"\",\"2625\":\"\\\\\",\"2626\":\"\\\"\",\"2627\":\"\\\"\",\"2628\":\",\",\"2629\":\"\\\"\",\"2630\":\"2\",\"2631\":\"6\",\"2632\":\"1\",\"2633\":\"\\\"\",\"2634\":\":\",\"2635\":\"\\\"\",\"2636\":\":\",\"2637\":\"\\\"\",\"2638\":\",\",\"2639\":\"\\\"\",\"2640\":\"2\",\"2641\":\"6\",\"2642\":\"2\",\"2643\":\"\\\"\",\"2644\":\":\",\"2645\":\"\\\"\",\"2646\":\"\\\\\",\"2647\":\"\\\"\",\"2648\":\"\\\"\",\"2649\":\",\",\"2650\":\"\\\"\",\"2651\":\"2\",\"2652\":\"6\",\"2653\":\"3\",\"2654\":\"\\\"\",\"2655\":\":\",\"2656\":\"\\\"\",\"2657\":\"o\",\"2658\":\"\\\"\",\"2659\":\",\",\"2660\":\"\\\"\",\"2661\":\"2\",\"2662\":\"6\",\"2663\":\"4\",\"2664\":\"\\\"\",\"2665\":\":\",\"2666\":\"\\\"\",\"2667\":\"\\\\\",\"2668\":\"\\\"\",\"2669\":\"\\\"\",\"2670\":\",\",\"2671\":\"\\\"\",\"2672\":\"2\",\"2673\":\"6\",\"2674\":\"5\",\"2675\":\"\\\"\",\"2676\":\":\",\"2677\":\"\\\"\",\"2678\":\",\",\"2679\":\"\\\"\",\"2680\":\",\",\"2681\":\"\\\"\",\"2682\":\"2\",\"2683\":\"6\",\"2684\":\"6\",\"2685\":\"\\\"\",\"2686\":\":\",\"2687\":\"\\\"\",\"2688\":\"\\\\\",\"2689\":\"\\\"\",\"2690\":\"\\\"\",\"2691\":\",\",\"2692\":\"\\\"\",\"2693\":\"2\",\"2694\":\"6\",\"2695\":\"7\",\"2696\":\"\\\"\",\"2697\":\":\",\"2698\":\"\\\"\",\"2699\":\"3\",\"2700\":\"\\\"\",\"2701\":\",\",\"2702\":\"\\\"\",\"2703\":\"2\",\"2704\":\"6\",\"2705\":\"8\",\"2706\":\"\\\"\",\"2707\":\":\",\"2708\":\"\\\"\",\"2709\":\"0\",\"2710\":\"\\\"\",\"2711\":\",\",\"2712\":\"\\\"\",\"2713\":\"2\",\"2714\":\"6\",\"2715\":\"9\",\"2716\":\"\\\"\",\"2717\":\":\",\"2718\":\"\\\"\",\"2719\":\"\\\\\",\"2720\":\"\\\"\",\"2721\":\"\\\"\",\"2722\":\",\",\"2723\":\"\\\"\",\"2724\":\"2\",\"2725\":\"7\",\"2726\":\"0\",\"2727\":\"\\\"\",\"2728\":\":\",\"2729\":\"\\\"\",\"2730\":\":\",\"2731\":\"\\\"\",\"2732\":\",\",\"2733\":\"\\\"\",\"2734\":\"2\",\"2735\":\"7\",\"2736\":\"1\",\"2737\":\"\\\"\",\"2738\":\":\",\"2739\":\"\\\"\",\"2740\":\"\\\\\",\"2741\":\"\\\"\",\"2742\":\"\\\"\",\"2743\":\",\",\"2744\":\"\\\"\",\"2745\":\"2\",\"2746\":\"7\",\"2747\":\"2\",\"2748\":\"\\\"\",\"2749\":\":\",\"2750\":\"\\\"\",\"2751\":\"c\",\"2752\":\"\\\"\",\"2753\":\",\",\"2754\":\"\\\"\",\"2755\":\"2\",\"2756\":\"7\",\"2757\":\"3\",\"2758\":\"\\\"\",\"2759\":\":\",\"2760\":\"\\\"\",\"2761\":\"\\\\\",\"2762\":\"\\\"\",\"2763\":\"\\\"\",\"2764\":\",\",\"2765\":\"\\\"\",\"2766\":\"2\",\"2767\":\"7\",\"2768\":\"4\",\"2769\":\"\\\"\",\"2770\":\":\",\"2771\":\"\\\"\",\"2772\":\",\",\"2773\":\"\\\"\",\"2774\":\",\",\"2775\":\"\\\"\",\"2776\":\"2\",\"2777\":\"7\",\"2778\":\"5\",\"2779\":\"\\\"\",\"2780\":\":\",\"2781\":\"\\\"\",\"2782\":\"\\\\\",\"2783\":\"\\\"\",\"2784\":\"\\\"\",\"2785\":\",\",\"2786\":\"\\\"\",\"2787\":\"2\",\"2788\":\"7\",\"2789\":\"6\",\"2790\":\"\\\"\",\"2791\":\":\",\"2792\":\"\\\"\",\"2793\":\"3\",\"2794\":\"\\\"\",\"2795\":\",\",\"2796\":\"\\\"\",\"2797\":\"2\",\"2798\":\"7\",\"2799\":\"7\",\"2800\":\"\\\"\",\"2801\":\":\",\"2802\":\"\\\"\",\"2803\":\"1\",\"2804\":\"\\\"\",\"2805\":\",\",\"2806\":\"\\\"\",\"2807\":\"2\",\"2808\":\"7\",\"2809\":\"8\",\"2810\":\"\\\"\",\"2811\":\":\",\"2812\":\"\\\"\",\"2813\":\"\\\\\",\"2814\":\"\\\"\",\"2815\":\"\\\"\",\"2816\":\",\",\"2817\":\"\\\"\",\"2818\":\"2\",\"2819\":\"7\",\"2820\":\"9\",\"2821\":\"\\\"\",\"2822\":\":\",\"2823\":\"\\\"\",\"2824\":\":\",\"2825\":\"\\\"\",\"2826\":\",\",\"2827\":\"\\\"\",\"2828\":\"2\",\"2829\":\"8\",\"2830\":\"0\",\"2831\":\"\\\"\",\"2832\":\":\",\"2833\":\"\\\"\",\"2834\":\"\\\\\",\"2835\":\"\\\"\",\"2836\":\"\\\"\",\"2837\":\",\",\"2838\":\"\\\"\",\"2839\":\"2\",\"2840\":\"8\",\"2841\":\"1\",\"2842\":\"\\\"\",\"2843\":\":\",\"2844\":\"\\\"\",\"2845\":\"a\",\"2846\":\"\\\"\",\"2847\":\",\",\"2848\":\"\\\"\",\"2849\":\"2\",\"2850\":\"8\",\"2851\":\"2\",\"2852\":\"\\\"\",\"2853\":\":\",\"2854\":\"\\\"\",\"2855\":\"\\\\\",\"2856\":\"\\\"\",\"2857\":\"\\\"\",\"2858\":\",\",\"2859\":\"\\\"\",\"2860\":\"2\",\"2861\":\"8\",\"2862\":\"3\",\"2863\":\"\\\"\",\"2864\":\":\",\"2865\":\"\\\"\",\"2866\":\",\",\"2867\":\"\\\"\",\"2868\":\",\",\"2869\":\"\\\"\",\"2870\":\"2\",\"2871\":\"8\",\"2872\":\"4\",\"2873\":\"\\\"\",\"2874\":\":\",\"2875\":\"\\\"\",\"2876\":\"\\\\\",\"2877\":\"\\\"\",\"2878\":\"\\\"\",\"2879\":\",\",\"2880\":\"\\\"\",\"2881\":\"2\",\"2882\":\"8\",\"2883\":\"5\",\"2884\":\"\\\"\",\"2885\":\":\",\"2886\":\"\\\"\",\"2887\":\"3\",\"2888\":\"\\\"\",\"2889\":\",\",\"2890\":\"\\\"\",\"2891\":\"2\",\"2892\":\"8\",\"2893\":\"6\",\"2894\":\"\\\"\",\"2895\":\":\",\"2896\":\"\\\"\",\"2897\":\"2\",\"2898\":\"\\\"\",\"2899\":\",\",\"2900\":\"\\\"\",\"2901\":\"2\",\"2902\":\"8\",\"2903\":\"7\",\"2904\":\"\\\"\",\"2905\":\":\",\"2906\":\"\\\"\",\"2907\":\"\\\\\",\"2908\":\"\\\"\",\"2909\":\"\\\"\",\"2910\":\",\",\"2911\":\"\\\"\",\"2912\":\"2\",\"2913\":\"8\",\"2914\":\"8\",\"2915\":\"\\\"\",\"2916\":\":\",\"2917\":\"\\\"\",\"2918\":\":\",\"2919\":\"\\\"\",\"2920\":\",\",\"2921\":\"\\\"\",\"2922\":\"2\",\"2923\":\"8\",\"2924\":\"9\",\"2925\":\"\\\"\",\"2926\":\":\",\"2927\":\"\\\"\",\"2928\":\"\\\\\",\"2929\":\"\\\"\",\"2930\":\"\\\"\",\"2931\":\",\",\"2932\":\"\\\"\",\"2933\":\"2\",\"2934\":\"9\",\"2935\":\"0\",\"2936\":\"\\\"\",\"2937\":\":\",\"2938\":\"\\\"\",\"2939\":\"l\",\"2940\":\"\\\"\",\"2941\":\",\",\"2942\":\"\\\"\",\"2943\":\"2\",\"2944\":\"9\",\"2945\":\"1\",\"2946\":\"\\\"\",\"2947\":\":\",\"2948\":\"\\\"\",\"2949\":\"\\\\\",\"2950\":\"\\\"\",\"2951\":\"\\\"\",\"2952\":\",\",\"2953\":\"\\\"\",\"2954\":\"2\",\"2955\":\"9\",\"2956\":\"2\",\"2957\":\"\\\"\",\"2958\":\":\",\"2959\":\"\\\"\",\"2960\":\",\",\"2961\":\"\\\"\",\"2962\":\",\",\"2963\":\"\\\"\",\"2964\":\"2\",\"2965\":\"9\",\"2966\":\"3\",\"2967\":\"\\\"\",\"2968\":\":\",\"2969\":\"\\\"\",\"2970\":\"\\\\\",\"2971\":\"\\\"\",\"2972\":\"\\\"\",\"2973\":\",\",\"2974\":\"\\\"\",\"2975\":\"2\",\"2976\":\"9\",\"2977\":\"4\",\"2978\":\"\\\"\",\"2979\":\":\",\"2980\":\"\\\"\",\"2981\":\"3\",\"2982\":\"\\\"\",\"2983\":\",\",\"2984\":\"\\\"\",\"2985\":\"2\",\"2986\":\"9\",\"2987\":\"5\",\"2988\":\"\\\"\",\"2989\":\":\",\"2990\":\"\\\"\",\"2991\":\"3\",\"2992\":\"\\\"\",\"2993\":\",\",\"2994\":\"\\\"\",\"2995\":\"2\",\"2996\":\"9\",\"2997\":\"6\",\"2998\":\"\\\"\",\"2999\":\":\",\"3000\":\"\\\"\",\"3001\":\"\\\\\",\"3002\":\"\\\"\",\"3003\":\"\\\"\",\"3004\":\",\",\"3005\":\"\\\"\",\"3006\":\"2\",\"3007\":\"9\",\"3008\":\"7\",\"3009\":\"\\\"\",\"3010\":\":\",\"3011\":\"\\\"\",\"3012\":\":\",\"3013\":\"\\\"\",\"3014\":\",\",\"3015\":\"\\\"\",\"3016\":\"2\",\"3017\":\"9\",\"3018\":\"8\",\"3019\":\"\\\"\",\"3020\":\":\",\"3021\":\"\\\"\",\"3022\":\"\\\\\",\"3023\":\"\\\"\",\"3024\":\"\\\"\",\"3025\":\",\",\"3026\":\"\\\"\",\"3027\":\"2\",\"3028\":\"9\",\"3029\":\"9\",\"3030\":\"\\\"\",\"3031\":\":\",\"3032\":\"\\\"\",\"3033\":\"e\",\"3034\":\"\\\"\",\"3035\":\",\",\"3036\":\"\\\"\",\"3037\":\"3\",\"3038\":\"0\",\"3039\":\"0\",\"3040\":\"\\\"\",\"3041\":\":\",\"3042\":\"\\\"\",\"3043\":\"\\\\\",\"3044\":\"\\\"\",\"3045\":\"\\\"\",\"3046\":\",\",\"3047\":\"\\\"\",\"3048\":\"3\",\"3049\":\"0\",\"3050\":\"1\",\"3051\":\"\\\"\",\"3052\":\":\",\"3053\":\"\\\"\",\"3054\":\",\",\"3055\":\"\\\"\",\"3056\":\",\",\"3057\":\"\\\"\",\"3058\":\"3\",\"3059\":\"0\",\"3060\":\"2\",\"3061\":\"\\\"\",\"3062\":\":\",\"3063\":\"\\\"\",\"3064\":\"\\\\\",\"3065\":\"\\\"\",\"3066\":\"\\\"\",\"3067\":\",\",\"3068\":\"\\\"\",\"3069\":\"3\",\"3070\":\"0\",\"3071\":\"3\",\"3072\":\"\\\"\",\"3073\":\":\",\"3074\":\"\\\"\",\"3075\":\"3\",\"3076\":\"\\\"\",\"3077\":\",\",\"3078\":\"\\\"\",\"3079\":\"3\",\"3080\":\"0\",\"3081\":\"4\",\"3082\":\"\\\"\",\"3083\":\":\",\"3084\":\"\\\"\",\"3085\":\"4\",\"3086\":\"\\\"\",\"3087\":\",\",\"3088\":\"\\\"\",\"3089\":\"3\",\"3090\":\"0\",\"3091\":\"5\",\"3092\":\"\\\"\",\"3093\":\":\",\"3094\":\"\\\"\",\"3095\":\"\\\\\",\"3096\":\"\\\"\",\"3097\":\"\\\"\",\"3098\":\",\",\"3099\":\"\\\"\",\"3100\":\"3\",\"3101\":\"0\",\"3102\":\"6\",\"3103\":\"\\\"\",\"3104\":\":\",\"3105\":\"\\\"\",\"3106\":\":\",\"3107\":\"\\\"\",\"3108\":\",\",\"3109\":\"\\\"\",\"3110\":\"3\",\"3111\":\"0\",\"3112\":\"7\",\"3113\":\"\\\"\",\"3114\":\":\",\"3115\":\"\\\"\",\"3116\":\"\\\\\",\"3117\":\"\\\"\",\"3118\":\"\\\"\",\"3119\":\",\",\"3120\":\"\\\"\",\"3121\":\"3\",\"3122\":\"0\",\"3123\":\"8\",\"3124\":\"\\\"\",\"3125\":\":\",\"3126\":\"\\\"\",\"3127\":\"\\\\\",\"3128\":\"\\\\\",\"3129\":\"\\\"\",\"3130\":\",\",\"3131\":\"\\\"\",\"3132\":\"3\",\"3133\":\"0\",\"3134\":\"9\",\"3135\":\"\\\"\",\"3136\":\":\",\"3137\":\"\\\"\",\"3138\":\"\\\\\",\"3139\":\"\\\"\",\"3140\":\"\\\"\",\"3141\":\",\",\"3142\":\"\\\"\",\"3143\":\"3\",\"3144\":\"1\",\"3145\":\"0\",\"3146\":\"\\\"\",\"3147\":\":\",\"3148\":\"\\\"\",\"3149\":\"\\\\\",\"3150\":\"\\\"\",\"3151\":\"\\\"\",\"3152\":\",\",\"3153\":\"\\\"\",\"3154\":\"3\",\"3155\":\"1\",\"3156\":\"1\",\"3157\":\"\\\"\",\"3158\":\":\",\"3159\":\"\\\"\",\"3160\":\",\",\"3161\":\"\\\"\",\"3162\":\",\",\"3163\":\"\\\"\",\"3164\":\"3\",\"3165\":\"1\",\"3166\":\"2\",\"3167\":\"\\\"\",\"3168\":\":\",\"3169\":\"\\\"\",\"3170\":\"\\\\\",\"3171\":\"\\\"\",\"3172\":\"\\\"\",\"3173\":\",\",\"3174\":\"\\\"\",\"3175\":\"3\",\"3176\":\"1\",\"3177\":\"3\",\"3178\":\"\\\"\",\"3179\":\":\",\"3180\":\"\\\"\",\"3181\":\"3\",\"3182\":\"\\\"\",\"3183\":\",\",\"3184\":\"\\\"\",\"3185\":\"3\",\"3186\":\"1\",\"3187\":\"4\",\"3188\":\"\\\"\",\"3189\":\":\",\"3190\":\"\\\"\",\"3191\":\"5\",\"3192\":\"\\\"\",\"3193\":\",\",\"3194\":\"\\\"\",\"3195\":\"3\",\"3196\":\"1\",\"3197\":\"5\",\"3198\":\"\\\"\",\"3199\":\":\",\"3200\":\"\\\"\",\"3201\":\"\\\\\",\"3202\":\"\\\"\",\"3203\":\"\\\"\",\"3204\":\",\",\"3205\":\"\\\"\",\"3206\":\"3\",\"3207\":\"1\",\"3208\":\"6\",\"3209\":\"\\\"\",\"3210\":\":\",\"3211\":\"\\\"\",\"3212\":\":\",\"3213\":\"\\\"\",\"3214\":\",\",\"3215\":\"\\\"\",\"3216\":\"3\",\"3217\":\"1\",\"3218\":\"7\",\"3219\":\"\\\"\",\"3220\":\":\",\"3221\":\"\\\"\",\"3222\":\"\\\\\",\"3223\":\"\\\"\",\"3224\":\"\\\"\",\"3225\":\",\",\"3226\":\"\\\"\",\"3227\":\"3\",\"3228\":\"1\",\"3229\":\"8\",\"3230\":\"\\\"\",\"3231\":\":\",\"3232\":\"\\\"\",\"3233\":\":\",\"3234\":\"\\\"\",\"3235\":\",\",\"3236\":\"\\\"\",\"3237\":\"3\",\"3238\":\"1\",\"3239\":\"9\",\"3240\":\"\\\"\",\"3241\":\":\",\"3242\":\"\\\"\",\"3243\":\"\\\\\",\"3244\":\"\\\"\",\"3245\":\"\\\"\",\"3246\":\",\",\"3247\":\"\\\"\",\"3248\":\"3\",\"3249\":\"2\",\"3250\":\"0\",\"3251\":\"\\\"\",\"3252\":\":\",\"3253\":\"\\\"\",\"3254\":\",\",\"3255\":\"\\\"\",\"3256\":\",\",\"3257\":\"\\\"\",\"3258\":\"3\",\"3259\":\"2\",\"3260\":\"1\",\"3261\":\"\\\"\",\"3262\":\":\",\"3263\":\"\\\"\",\"3264\":\"\\\\\",\"3265\":\"\\\"\",\"3266\":\"\\\"\",\"3267\":\",\",\"3268\":\"\\\"\",\"3269\":\"3\",\"3270\":\"2\",\"3271\":\"2\",\"3272\":\"\\\"\",\"3273\":\":\",\"3274\":\"\\\"\",\"3275\":\"3\",\"3276\":\"\\\"\",\"3277\":\",\",\"3278\":\"\\\"\",\"3279\":\"3\",\"3280\":\"2\",\"3281\":\"3\",\"3282\":\"\\\"\",\"3283\":\":\",\"3284\":\"\\\"\",\"3285\":\"6\",\"3286\":\"\\\"\",\"3287\":\",\",\"3288\":\"\\\"\",\"3289\":\"3\",\"3290\":\"2\",\"3291\":\"4\",\"3292\":\"\\\"\",\"3293\":\":\",\"3294\":\"\\\"\",\"3295\":\"\\\\\",\"3296\":\"\\\"\",\"3297\":\"\\\"\",\"3298\":\",\",\"3299\":\"\\\"\",\"3300\":\"3\",\"3301\":\"2\",\"3302\":\"5\",\"3303\":\"\\\"\",\"3304\":\":\",\"3305\":\"\\\"\",\"3306\":\":\",\"3307\":\"\\\"\",\"3308\":\",\",\"3309\":\"\\\"\",\"3310\":\"3\",\"3311\":\"2\",\"3312\":\"6\",\"3313\":\"\\\"\",\"3314\":\":\",\"3315\":\"\\\"\",\"3316\":\"\\\\\",\"3317\":\"\\\"\",\"3318\":\"\\\"\",\"3319\":\",\",\"3320\":\"\\\"\",\"3321\":\"3\",\"3322\":\"2\",\"3323\":\"7\",\"3324\":\"\\\"\",\"3325\":\":\",\"3326\":\"\\\"\",\"3327\":\"\\\\\",\"3328\":\"\\\\\",\"3329\":\"\\\"\",\"3330\":\",\",\"3331\":\"\\\"\",\"3332\":\"3\",\"3333\":\"2\",\"3334\":\"8\",\"3335\":\"\\\"\",\"3336\":\":\",\"3337\":\"\\\"\",\"3338\":\"\\\\\",\"3339\":\"\\\"\",\"3340\":\"\\\"\",\"3341\":\",\",\"3342\":\"\\\"\",\"3343\":\"3\",\"3344\":\"2\",\"3345\":\"9\",\"3346\":\"\\\"\",\"3347\":\":\",\"3348\":\"\\\"\",\"3349\":\"\\\\\",\"3350\":\"\\\"\",\"3351\":\"\\\"\",\"3352\":\",\",\"3353\":\"\\\"\",\"3354\":\"3\",\"3355\":\"3\",\"3356\":\"0\",\"3357\":\"\\\"\",\"3358\":\":\",\"3359\":\"\\\"\",\"3360\":\",\",\"3361\":\"\\\"\",\"3362\":\",\",\"3363\":\"\\\"\",\"3364\":\"3\",\"3365\":\"3\",\"3366\":\"1\",\"3367\":\"\\\"\",\"3368\":\":\",\"3369\":\"\\\"\",\"3370\":\"\\\\\",\"3371\":\"\\\"\",\"3372\":\"\\\"\",\"3373\":\",\",\"3374\":\"\\\"\",\"3375\":\"3\",\"3376\":\"3\",\"3377\":\"2\",\"3378\":\"\\\"\",\"3379\":\":\",\"3380\":\"\\\"\",\"3381\":\"3\",\"3382\":\"\\\"\",\"3383\":\",\",\"3384\":\"\\\"\",\"3385\":\"3\",\"3386\":\"3\",\"3387\":\"3\",\"3388\":\"\\\"\",\"3389\":\":\",\"3390\":\"\\\"\",\"3391\":\"7\",\"3392\":\"\\\"\",\"3393\":\",\",\"3394\":\"\\\"\",\"3395\":\"3\",\"3396\":\"3\",\"3397\":\"4\",\"3398\":\"\\\"\",\"3399\":\":\",\"3400\":\"\\\"\",\"3401\":\"\\\\\",\"3402\":\"\\\"\",\"3403\":\"\\\"\",\"3404\":\",\",\"3405\":\"\\\"\",\"3406\":\"3\",\"3407\":\"3\",\"3408\":\"5\",\"3409\":\"\\\"\",\"3410\":\":\",\"3411\":\"\\\"\",\"3412\":\":\",\"3413\":\"\\\"\",\"3414\":\",\",\"3415\":\"\\\"\",\"3416\":\"3\",\"3417\":\"3\",\"3418\":\"6\",\"3419\":\"\\\"\",\"3420\":\":\",\"3421\":\"\\\"\",\"3422\":\"\\\\\",\"3423\":\"\\\"\",\"3424\":\"\\\"\",\"3425\":\",\",\"3426\":\"\\\"\",\"3427\":\"3\",\"3428\":\"3\",\"3429\":\"7\",\"3430\":\"\\\"\",\"3431\":\":\",\"3432\":\"\\\"\",\"3433\":\"e\",\"3434\":\"\\\"\",\"3435\":\",\",\"3436\":\"\\\"\",\"3437\":\"3\",\"3438\":\"3\",\"3439\":\"8\",\"3440\":\"\\\"\",\"3441\":\":\",\"3442\":\"\\\"\",\"3443\":\"\\\\\",\"3444\":\"\\\"\",\"3445\":\"\\\"\",\"3446\":\",\",\"3447\":\"\\\"\",\"3448\":\"3\",\"3449\":\"3\",\"3450\":\"9\",\"3451\":\"\\\"\",\"3452\":\":\",\"3453\":\"\\\"\",\"3454\":\",\",\"3455\":\"\\\"\",\"3456\":\",\",\"3457\":\"\\\"\",\"3458\":\"3\",\"3459\":\"4\",\"3460\":\"0\",\"3461\":\"\\\"\",\"3462\":\":\",\"3463\":\"\\\"\",\"3464\":\"\\\\\",\"3465\":\"\\\"\",\"3466\":\"\\\"\",\"3467\":\",\",\"3468\":\"\\\"\",\"3469\":\"3\",\"3470\":\"4\",\"3471\":\"1\",\"3472\":\"\\\"\",\"3473\":\":\",\"3474\":\"\\\"\",\"3475\":\"3\",\"3476\":\"\\\"\",\"3477\":\",\",\"3478\":\"\\\"\",\"3479\":\"3\",\"3480\":\"4\",\"3481\":\"2\",\"3482\":\"\\\"\",\"3483\":\":\",\"3484\":\"\\\"\",\"3485\":\"8\",\"3486\":\"\\\"\",\"3487\":\",\",\"3488\":\"\\\"\",\"3489\":\"3\",\"3490\":\"4\",\"3491\":\"3\",\"3492\":\"\\\"\",\"3493\":\":\",\"3494\":\"\\\"\",\"3495\":\"\\\\\",\"3496\":\"\\\"\",\"3497\":\"\\\"\",\"3498\":\",\",\"3499\":\"\\\"\",\"3500\":\"3\",\"3501\":\"4\",\"3502\":\"4\",\"3503\":\"\\\"\",\"3504\":\":\",\"3505\":\"\\\"\",\"3506\":\":\",\"3507\":\"\\\"\",\"3508\":\",\",\"3509\":\"\\\"\",\"3510\":\"3\",\"3511\":\"4\",\"3512\":\"5\",\"3513\":\"\\\"\",\"3514\":\":\",\"3515\":\"\\\"\",\"3516\":\"\\\\\",\"3517\":\"\\\"\",\"3518\":\"\\\"\",\"3519\":\",\",\"3520\":\"\\\"\",\"3521\":\"3\",\"3522\":\"4\",\"3523\":\"6\",\"3524\":\"\\\"\",\"3525\":\":\",\"3526\":\"\\\"\",\"3527\":\"n\",\"3528\":\"\\\"\",\"3529\":\",\",\"3530\":\"\\\"\",\"3531\":\"3\",\"3532\":\"4\",\"3533\":\"7\",\"3534\":\"\\\"\",\"3535\":\":\",\"3536\":\"\\\"\",\"3537\":\"\\\\\",\"3538\":\"\\\"\",\"3539\":\"\\\"\",\"3540\":\",\",\"3541\":\"\\\"\",\"3542\":\"3\",\"3543\":\"4\",\"3544\":\"8\",\"3545\":\"\\\"\",\"3546\":\":\",\"3547\":\"\\\"\",\"3548\":\",\",\"3549\":\"\\\"\",\"3550\":\",\",\"3551\":\"\\\"\",\"3552\":\"3\",\"3553\":\"4\",\"3554\":\"9\",\"3555\":\"\\\"\",\"3556\":\":\",\"3557\":\"\\\"\",\"3558\":\"\\\\\",\"3559\":\"\\\"\",\"3560\":\"\\\"\",\"3561\":\",\",\"3562\":\"\\\"\",\"3563\":\"3\",\"3564\":\"5\",\"3565\":\"0\",\"3566\":\"\\\"\",\"3567\":\":\",\"3568\":\"\\\"\",\"3569\":\"3\",\"3570\":\"\\\"\",\"3571\":\",\",\"3572\":\"\\\"\",\"3573\":\"3\",\"3574\":\"5\",\"3575\":\"1\",\"3576\":\"\\\"\",\"3577\":\":\",\"3578\":\"\\\"\",\"3579\":\"9\",\"3580\":\"\\\"\",\"3581\":\",\",\"3582\":\"\\\"\",\"3583\":\"3\",\"3584\":\"5\",\"3585\":\"2\",\"3586\":\"\\\"\",\"3587\":\":\",\"3588\":\"\\\"\",\"3589\":\"\\\\\",\"3590\":\"\\\"\",\"3591\":\"\\\"\",\"3592\":\",\",\"3593\":\"\\\"\",\"3594\":\"3\",\"3595\":\"5\",\"3596\":\"3\",\"3597\":\"\\\"\",\"3598\":\":\",\"3599\":\"\\\"\",\"3600\":\":\",\"3601\":\"\\\"\",\"3602\":\",\",\"3603\":\"\\\"\",\"3604\":\"3\",\"3605\":\"5\",\"3606\":\"4\",\"3607\":\"\\\"\",\"3608\":\":\",\"3609\":\"\\\"\",\"3610\":\"\\\\\",\"3611\":\"\\\"\",\"3612\":\"\\\"\",\"3613\":\",\",\"3614\":\"\\\"\",\"3615\":\"3\",\"3616\":\"5\",\"3617\":\"5\",\"3618\":\"\\\"\",\"3619\":\":\",\"3620\":\"\\\"\",\"3621\":\"-\",\"3622\":\"\\\"\",\"3623\":\",\",\"3624\":\"\\\"\",\"3625\":\"3\",\"3626\":\"5\",\"3627\":\"6\",\"3628\":\"\\\"\",\"3629\":\":\",\"3630\":\"\\\"\",\"3631\":\"\\\\\",\"3632\":\"\\\"\",\"3633\":\"\\\"\",\"3634\":\",\",\"3635\":\"\\\"\",\"3636\":\"3\",\"3637\":\"5\",\"3638\":\"7\",\"3639\":\"\\\"\",\"3640\":\":\",\"3641\":\"\\\"\",\"3642\":\",\",\"3643\":\"\\\"\",\"3644\":\",\",\"3645\":\"\\\"\",\"3646\":\"3\",\"3647\":\"5\",\"3648\":\"8\",\"3649\":\"\\\"\",\"3650\":\":\",\"3651\":\"\\\"\",\"3652\":\"\\\\\",\"3653\":\"\\\"\",\"3654\":\"\\\"\",\"3655\":\",\",\"3656\":\"\\\"\",\"3657\":\"3\",\"3658\":\"5\",\"3659\":\"9\",\"3660\":\"\\\"\",\"3661\":\":\",\"3662\":\"\\\"\",\"3663\":\"4\",\"3664\":\"\\\"\",\"3665\":\",\",\"3666\":\"\\\"\",\"3667\":\"3\",\"3668\":\"6\",\"3669\":\"0\",\"3670\":\"\\\"\",\"3671\":\":\",\"3672\":\"\\\"\",\"3673\":\"0\",\"3674\":\"\\\"\",\"3675\":\",\",\"3676\":\"\\\"\",\"3677\":\"3\",\"3678\":\"6\",\"3679\":\"1\",\"3680\":\"\\\"\",\"3681\":\":\",\"3682\":\"\\\"\",\"3683\":\"\\\\\",\"3684\":\"\\\"\",\"3685\":\"\\\"\",\"3686\":\",\",\"3687\":\"\\\"\",\"3688\":\"3\",\"3689\":\"6\",\"3690\":\"2\",\"3691\":\"\\\"\",\"3692\":\":\",\"3693\":\"\\\"\",\"3694\":\":\",\"3695\":\"\\\"\",\"3696\":\",\",\"3697\":\"\\\"\",\"3698\":\"3\",\"3699\":\"6\",\"3700\":\"3\",\"3701\":\"\\\"\",\"3702\":\":\",\"3703\":\"\\\"\",\"3704\":\"\\\\\",\"3705\":\"\\\"\",\"3706\":\"\\\"\",\"3707\":\",\",\"3708\":\"\\\"\",\"3709\":\"3\",\"3710\":\"6\",\"3711\":\"4\",\"3712\":\"\\\"\",\"3713\":\":\",\"3714\":\"\\\"\",\"3715\":\"I\",\"3716\":\"\\\"\",\"3717\":\",\",\"3718\":\"\\\"\",\"3719\":\"3\",\"3720\":\"6\",\"3721\":\"5\",\"3722\":\"\\\"\",\"3723\":\":\",\"3724\":\"\\\"\",\"3725\":\"\\\\\",\"3726\":\"\\\"\",\"3727\":\"\\\"\",\"3728\":\",\",\"3729\":\"\\\"\",\"3730\":\"3\",\"3731\":\"6\",\"3732\":\"6\",\"3733\":\"\\\"\",\"3734\":\":\",\"3735\":\"\\\"\",\"3736\":\",\",\"3737\":\"\\\"\",\"3738\":\",\",\"3739\":\"\\\"\",\"3740\":\"3\",\"3741\":\"6\",\"3742\":\"7\",\"3743\":\"\\\"\",\"3744\":\":\",\"3745\":\"\\\"\",\"3746\":\"\\\\\",\"3747\":\"\\\"\",\"3748\":\"\\\"\",\"3749\":\",\",\"3750\":\"\\\"\",\"3751\":\"3\",\"3752\":\"6\",\"3753\":\"8\",\"3754\":\"\\\"\",\"3755\":\":\",\"3756\":\"\\\"\",\"3757\":\"4\",\"3758\":\"\\\"\",\"3759\":\",\",\"3760\":\"\\\"\",\"3761\":\"3\",\"3762\":\"6\",\"3763\":\"9\",\"3764\":\"\\\"\",\"3765\":\":\",\"3766\":\"\\\"\",\"3767\":\"1\",\"3768\":\"\\\"\",\"3769\":\",\",\"3770\":\"\\\"\",\"3771\":\"3\",\"3772\":\"7\",\"3773\":\"0\",\"3774\":\"\\\"\",\"3775\":\":\",\"3776\":\"\\\"\",\"3777\":\"\\\\\",\"3778\":\"\\\"\",\"3779\":\"\\\"\",\"3780\":\",\",\"3781\":\"\\\"\",\"3782\":\"3\",\"3783\":\"7\",\"3784\":\"1\",\"3785\":\"\\\"\",\"3786\":\":\",\"3787\":\"\\\"\",\"3788\":\":\",\"3789\":\"\\\"\",\"3790\":\",\",\"3791\":\"\\\"\",\"3792\":\"3\",\"3793\":\"7\",\"3794\":\"2\",\"3795\":\"\\\"\",\"3796\":\":\",\"3797\":\"\\\"\",\"3798\":\"\\\\\",\"3799\":\"\\\"\",\"3800\":\"\\\"\",\"3801\":\",\",\"3802\":\"\\\"\",\"3803\":\"3\",\"3804\":\"7\",\"3805\":\"3\",\"3806\":\"\\\"\",\"3807\":\":\",\"3808\":\"\\\"\",\"3809\":\"N\",\"3810\":\"\\\"\",\"3811\":\",\",\"3812\":\"\\\"\",\"3813\":\"3\",\"3814\":\"7\",\"3815\":\"4\",\"3816\":\"\\\"\",\"3817\":\":\",\"3818\":\"\\\"\",\"3819\":\"\\\\\",\"3820\":\"\\\"\",\"3821\":\"\\\"\",\"3822\":\",\",\"3823\":\"\\\"\",\"3824\":\"3\",\"3825\":\"7\",\"3826\":\"5\",\"3827\":\"\\\"\",\"3828\":\":\",\"3829\":\"\\\"\",\"3830\":\",\",\"3831\":\"\\\"\",\"3832\":\",\",\"3833\":\"\\\"\",\"3834\":\"3\",\"3835\":\"7\",\"3836\":\"6\",\"3837\":\"\\\"\",\"3838\":\":\",\"3839\":\"\\\"\",\"3840\":\"\\\\\",\"3841\":\"\\\"\",\"3842\":\"\\\"\",\"3843\":\",\",\"3844\":\"\\\"\",\"3845\":\"3\",\"3846\":\"7\",\"3847\":\"7\",\"3848\":\"\\\"\",\"3849\":\":\",\"3850\":\"\\\"\",\"3851\":\"4\",\"3852\":\"\\\"\",\"3853\":\",\",\"3854\":\"\\\"\",\"3855\":\"3\",\"3856\":\"7\",\"3857\":\"8\",\"3858\":\"\\\"\",\"3859\":\":\",\"3860\":\"\\\"\",\"3861\":\"2\",\"3862\":\"\\\"\",\"3863\":\",\",\"3864\":\"\\\"\",\"3865\":\"3\",\"3866\":\"7\",\"3867\":\"9\",\"3868\":\"\\\"\",\"3869\":\":\",\"3870\":\"\\\"\",\"3871\":\"\\\\\",\"3872\":\"\\\"\",\"3873\":\"\\\"\",\"3874\":\",\",\"3875\":\"\\\"\",\"3876\":\"3\",\"3877\":\"8\",\"3878\":\"0\",\"3879\":\"\\\"\",\"3880\":\":\",\"3881\":\"\\\"\",\"3882\":\":\",\"3883\":\"\\\"\",\"3884\":\",\",\"3885\":\"\\\"\",\"3886\":\"3\",\"3887\":\"8\",\"3888\":\"1\",\"3889\":\"\\\"\",\"3890\":\":\",\"3891\":\"\\\"\",\"3892\":\"\\\\\",\"3893\":\"\\\"\",\"3894\":\"\\\"\",\"3895\":\",\",\"3896\":\"\\\"\",\"3897\":\"3\",\"3898\":\"8\",\"3899\":\"2\",\"3900\":\"\\\"\",\"3901\":\":\",\"3902\":\"\\\"\",\"3903\":\"\\\\\",\"3904\":\"\\\\\",\"3905\":\"\\\"\",\"3906\":\",\",\"3907\":\"\\\"\",\"3908\":\"3\",\"3909\":\"8\",\"3910\":\"3\",\"3911\":\"\\\"\",\"3912\":\":\",\"3913\":\"\\\"\",\"3914\":\"\\\\\",\"3915\":\"\\\"\",\"3916\":\"\\\"\",\"3917\":\",\",\"3918\":\"\\\"\",\"3919\":\"3\",\"3920\":\"8\",\"3921\":\"4\",\"3922\":\"\\\"\",\"3923\":\":\",\"3924\":\"\\\"\",\"3925\":\"\\\\\",\"3926\":\"\\\"\",\"3927\":\"\\\"\",\"3928\":\",\",\"3929\":\"\\\"\",\"3930\":\"3\",\"3931\":\"8\",\"3932\":\"5\",\"3933\":\"\\\"\",\"3934\":\":\",\"3935\":\"\\\"\",\"3936\":\",\",\"3937\":\"\\\"\",\"3938\":\",\",\"3939\":\"\\\"\",\"3940\":\"3\",\"3941\":\"8\",\"3942\":\"6\",\"3943\":\"\\\"\",\"3944\":\":\",\"3945\":\"\\\"\",\"3946\":\"\\\\\",\"3947\":\"\\\"\",\"3948\":\"\\\"\",\"3949\":\",\",\"3950\":\"\\\"\",\"3951\":\"3\",\"3952\":\"8\",\"3953\":\"7\",\"3954\":\"\\\"\",\"3955\":\":\",\"3956\":\"\\\"\",\"3957\":\"4\",\"3958\":\"\\\"\",\"3959\":\",\",\"3960\":\"\\\"\",\"3961\":\"3\",\"3962\":\"8\",\"3963\":\"8\",\"3964\":\"\\\"\",\"3965\":\":\",\"3966\":\"\\\"\",\"3967\":\"3\",\"3968\":\"\\\"\",\"3969\":\",\",\"3970\":\"\\\"\",\"3971\":\"3\",\"3972\":\"8\",\"3973\":\"9\",\"3974\":\"\\\"\",\"3975\":\":\",\"3976\":\"\\\"\",\"3977\":\"\\\\\",\"3978\":\"\\\"\",\"3979\":\"\\\"\",\"3980\":\",\",\"3981\":\"\\\"\",\"3982\":\"3\",\"3983\":\"9\",\"3984\":\"0\",\"3985\":\"\\\"\",\"3986\":\":\",\"3987\":\"\\\"\",\"3988\":\":\",\"3989\":\"\\\"\",\"3990\":\",\",\"3991\":\"\\\"\",\"3992\":\"3\",\"3993\":\"9\",\"3994\":\"1\",\"3995\":\"\\\"\",\"3996\":\":\",\"3997\":\"\\\"\",\"3998\":\"\\\\\",\"3999\":\"\\\"\",\"4000\":\"\\\"\",\"4001\":\",\",\"4002\":\"\\\"\",\"4003\":\"3\",\"4004\":\"9\",\"4005\":\"2\",\"4006\":\"\\\"\",\"4007\":\":\",\"4008\":\"\\\"\",\"4009\":\"}\",\"4010\":\"\\\"\",\"4011\":\",\",\"4012\":\"\\\"\",\"4013\":\"3\",\"4014\":\"9\",\"4015\":\"3\",\"4016\":\"\\\"\",\"4017\":\":\",\"4018\":\"\\\"\",\"4019\":\"\\\\\",\"4020\":\"\\\"\",\"4021\":\"\\\"\",\"4022\":\",\",\"4023\":\"\\\"\",\"4024\":\"3\",\"4025\":\"9\",\"4026\":\"4\",\"4027\":\"\\\"\",\"4028\":\":\",\"4029\":\"\\\"\",\"4030\":\",\",\"4031\":\"\\\"\",\"4032\":\",\",\"4033\":\"\\\"\",\"4034\":\"3\",\"4035\":\"9\",\"4036\":\"5\",\"4037\":\"\\\"\",\"4038\":\":\",\"4039\":\"\\\"\",\"4040\":\"\\\\\",\"4041\":\"\\\"\",\"4042\":\"\\\"\",\"4043\":\",\",\"4044\":\"\\\"\",\"4045\":\"3\",\"4046\":\"9\",\"4047\":\"6\",\"4048\":\"\\\"\",\"4049\":\":\",\"4050\":\"\\\"\",\"4051\":\"w\",\"4052\":\"\\\"\",\"4053\":\",\",\"4054\":\"\\\"\",\"4055\":\"3\",\"4056\":\"9\",\"4057\":\"7\",\"4058\":\"\\\"\",\"4059\":\":\",\"4060\":\"\\\"\",\"4061\":\"i\",\"4062\":\"\\\"\",\"4063\":\",\",\"4064\":\"\\\"\",\"4065\":\"3\",\"4066\":\"9\",\"4067\":\"8\",\"4068\":\"\\\"\",\"4069\":\":\",\"4070\":\"\\\"\",\"4071\":\"d\",\"4072\":\"\\\"\",\"4073\":\",\",\"4074\":\"\\\"\",\"4075\":\"3\",\"4076\":\"9\",\"4077\":\"9\",\"4078\":\"\\\"\",\"4079\":\":\",\"4080\":\"\\\"\",\"4081\":\"g\",\"4082\":\"\\\"\",\"4083\":\",\",\"4084\":\"\\\"\",\"4085\":\"4\",\"4086\":\"0\",\"4087\":\"0\",\"4088\":\"\\\"\",\"4089\":\":\",\"4090\":\"\\\"\",\"4091\":\"e\",\"4092\":\"\\\"\",\"4093\":\",\",\"4094\":\"\\\"\",\"4095\":\"4\",\"4096\":\"0\",\"4097\":\"1\",\"4098\":\"\\\"\",\"4099\":\":\",\"4100\":\"\\\"\",\"4101\":\"t\",\"4102\":\"\\\"\",\"4103\":\",\",\"4104\":\"\\\"\",\"4105\":\"4\",\"4106\":\"0\",\"4107\":\"2\",\"4108\":\"\\\"\",\"4109\":\":\",\"4110\":\"\\\"\",\"4111\":\"C\",\"4112\":\"\\\"\",\"4113\":\",\",\"4114\":\"\\\"\",\"4115\":\"4\",\"4116\":\"0\",\"4117\":\"3\",\"4118\":\"\\\"\",\"4119\":\":\",\"4120\":\"\\\"\",\"4121\":\"h\",\"4122\":\"\\\"\",\"4123\":\",\",\"4124\":\"\\\"\",\"4125\":\"4\",\"4126\":\"0\",\"4127\":\"4\",\"4128\":\"\\\"\",\"4129\":\":\",\"4130\":\"\\\"\",\"4131\":\"a\",\"4132\":\"\\\"\",\"4133\":\",\",\"4134\":\"\\\"\",\"4135\":\"4\",\"4136\":\"0\",\"4137\":\"5\",\"4138\":\"\\\"\",\"4139\":\":\",\"4140\":\"\\\"\",\"4141\":\"n\",\"4142\":\"\\\"\",\"4143\":\",\",\"4144\":\"\\\"\",\"4145\":\"4\",\"4146\":\"0\",\"4147\":\"6\",\"4148\":\"\\\"\",\"4149\":\":\",\"4150\":\"\\\"\",\"4151\":\"n\",\"4152\":\"\\\"\",\"4153\":\",\",\"4154\":\"\\\"\",\"4155\":\"4\",\"4156\":\"0\",\"4157\":\"7\",\"4158\":\"\\\"\",\"4159\":\":\",\"4160\":\"\\\"\",\"4161\":\"e\",\"4162\":\"\\\"\",\"4163\":\",\",\"4164\":\"\\\"\",\"4165\":\"4\",\"4166\":\"0\",\"4167\":\"8\",\"4168\":\"\\\"\",\"4169\":\":\",\"4170\":\"\\\"\",\"4171\":\"l\",\"4172\":\"\\\"\",\"4173\":\",\",\"4174\":\"\\\"\",\"4175\":\"4\",\"4176\":\"0\",\"4177\":\"9\",\"4178\":\"\\\"\",\"4179\":\":\",\"4180\":\"\\\"\",\"4181\":\"I\",\"4182\":\"\\\"\",\"4183\":\",\",\"4184\":\"\\\"\",\"4185\":\"4\",\"4186\":\"1\",\"4187\":\"0\",\"4188\":\"\\\"\",\"4189\":\":\",\"4190\":\"\\\"\",\"4191\":\"d\",\"4192\":\"\\\"\",\"4193\":\",\",\"4194\":\"\\\"\",\"4195\":\"4\",\"4196\":\"1\",\"4197\":\"1\",\"4198\":\"\\\"\",\"4199\":\":\",\"4200\":\"\\\"\",\"4201\":\"\\\\\",\"4202\":\"\\\"\",\"4203\":\"\\\"\",\"4204\":\",\",\"4205\":\"\\\"\",\"4206\":\"4\",\"4207\":\"1\",\"4208\":\"2\",\"4209\":\"\\\"\",\"4210\":\":\",\"4211\":\"\\\"\",\"4212\":\":\",\"4213\":\"\\\"\",\"4214\":\",\",\"4215\":\"\\\"\",\"4216\":\"4\",\"4217\":\"1\",\"4218\":\"3\",\"4219\":\"\\\"\",\"4220\":\":\",\"4221\":\"\\\"\",\"4222\":\"\\\\\",\"4223\":\"\\\"\",\"4224\":\"\\\"\",\"4225\":\",\",\"4226\":\"\\\"\",\"4227\":\"4\",\"4228\":\"1\",\"4229\":\"4\",\"4230\":\"\\\"\",\"4231\":\":\",\"4232\":\"\\\"\",\"4233\":\"8\",\"4234\":\"\\\"\",\"4235\":\",\",\"4236\":\"\\\"\",\"4237\":\"4\",\"4238\":\"1\",\"4239\":\"5\",\"4240\":\"\\\"\",\"4241\":\":\",\"4242\":\"\\\"\",\"4243\":\"6\",\"4244\":\"\\\"\",\"4245\":\",\",\"4246\":\"\\\"\",\"4247\":\"4\",\"4248\":\"1\",\"4249\":\"6\",\"4250\":\"\\\"\",\"4251\":\":\",\"4252\":\"\\\"\",\"4253\":\"7\",\"4254\":\"\\\"\",\"4255\":\",\",\"4256\":\"\\\"\",\"4257\":\"4\",\"4258\":\"1\",\"4259\":\"7\",\"4260\":\"\\\"\",\"4261\":\":\",\"4262\":\"\\\"\",\"4263\":\"f\",\"4264\":\"\\\"\",\"4265\":\",\",\"4266\":\"\\\"\",\"4267\":\"4\",\"4268\":\"1\",\"4269\":\"8\",\"4270\":\"\\\"\",\"4271\":\":\",\"4272\":\"\\\"\",\"4273\":\"3\",\"4274\":\"\\\"\",\"4275\":\",\",\"4276\":\"\\\"\",\"4277\":\"4\",\"4278\":\"1\",\"4279\":\"9\",\"4280\":\"\\\"\",\"4281\":\":\",\"4282\":\"\\\"\",\"4283\":\"6\",\"4284\":\"\\\"\",\"4285\":\",\",\"4286\":\"\\\"\",\"4287\":\"4\",\"4288\":\"2\",\"4289\":\"0\",\"4290\":\"\\\"\",\"4291\":\":\",\"4292\":\"\\\"\",\"4293\":\"e\",\"4294\":\"\\\"\",\"4295\":\",\",\"4296\":\"\\\"\",\"4297\":\"4\",\"4298\":\"2\",\"4299\":\"1\",\"4300\":\"\\\"\",\"4301\":\":\",\"4302\":\"\\\"\",\"4303\":\"8\",\"4304\":\"\\\"\",\"4305\":\",\",\"4306\":\"\\\"\",\"4307\":\"4\",\"4308\":\"2\",\"4309\":\"2\",\"4310\":\"\\\"\",\"4311\":\":\",\"4312\":\"\\\"\",\"4313\":\"-\",\"4314\":\"\\\"\",\"4315\":\",\",\"4316\":\"\\\"\",\"4317\":\"4\",\"4318\":\"2\",\"4319\":\"3\",\"4320\":\"\\\"\",\"4321\":\":\",\"4322\":\"\\\"\",\"4323\":\"1\",\"4324\":\"\\\"\",\"4325\":\",\",\"4326\":\"\\\"\",\"4327\":\"4\",\"4328\":\"2\",\"4329\":\"4\",\"4330\":\"\\\"\",\"4331\":\":\",\"4332\":\"\\\"\",\"4333\":\"0\",\"4334\":\"\\\"\",\"4335\":\",\",\"4336\":\"\\\"\",\"4337\":\"4\",\"4338\":\"2\",\"4339\":\"5\",\"4340\":\"\\\"\",\"4341\":\":\",\"4342\":\"\\\"\",\"4343\":\"5\",\"4344\":\"\\\"\",\"4345\":\",\",\"4346\":\"\\\"\",\"4347\":\"4\",\"4348\":\"2\",\"4349\":\"6\",\"4350\":\"\\\"\",\"4351\":\":\",\"4352\":\"\\\"\",\"4353\":\"5\",\"4354\":\"\\\"\",\"4355\":\",\",\"4356\":\"\\\"\",\"4357\":\"4\",\"4358\":\"2\",\"4359\":\"7\",\"4360\":\"\\\"\",\"4361\":\":\",\"4362\":\"\\\"\",\"4363\":\"-\",\"4364\":\"\\\"\",\"4365\":\",\",\"4366\":\"\\\"\",\"4367\":\"4\",\"4368\":\"2\",\"4369\":\"8\",\"4370\":\"\\\"\",\"4371\":\":\",\"4372\":\"\\\"\",\"4373\":\"4\",\"4374\":\"\\\"\",\"4375\":\",\",\"4376\":\"\\\"\",\"4377\":\"4\",\"4378\":\"2\",\"4379\":\"9\",\"4380\":\"\\\"\",\"4381\":\":\",\"4382\":\"\\\"\",\"4383\":\"6\",\"4384\":\"\\\"\",\"4385\":\",\",\"4386\":\"\\\"\",\"4387\":\"4\",\"4388\":\"3\",\"4389\":\"0\",\"4390\":\"\\\"\",\"4391\":\":\",\"4392\":\"\\\"\",\"4393\":\"8\",\"4394\":\"\\\"\",\"4395\":\",\",\"4396\":\"\\\"\",\"4397\":\"4\",\"4398\":\"3\",\"4399\":\"1\",\"4400\":\"\\\"\",\"4401\":\":\",\"4402\":\"\\\"\",\"4403\":\"5\",\"4404\":\"\\\"\",\"4405\":\",\",\"4406\":\"\\\"\",\"4407\":\"4\",\"4408\":\"3\",\"4409\":\"2\",\"4410\":\"\\\"\",\"4411\":\":\",\"4412\":\"\\\"\",\"4413\":\"-\",\"4414\":\"\\\"\",\"4415\":\",\",\"4416\":\"\\\"\",\"4417\":\"4\",\"4418\":\"3\",\"4419\":\"3\",\"4420\":\"\\\"\",\"4421\":\":\",\"4422\":\"\\\"\",\"4423\":\"9\",\"4424\":\"\\\"\",\"4425\":\",\",\"4426\":\"\\\"\",\"4427\":\"4\",\"4428\":\"3\",\"4429\":\"4\",\"4430\":\"\\\"\",\"4431\":\":\",\"4432\":\"\\\"\",\"4433\":\"a\",\"4434\":\"\\\"\",\"4435\":\",\",\"4436\":\"\\\"\",\"4437\":\"4\",\"4438\":\"3\",\"4439\":\"5\",\"4440\":\"\\\"\",\"4441\":\":\",\"4442\":\"\\\"\",\"4443\":\"2\",\"4444\":\"\\\"\",\"4445\":\",\",\"4446\":\"\\\"\",\"4447\":\"4\",\"4448\":\"3\",\"4449\":\"6\",\"4450\":\"\\\"\",\"4451\":\":\",\"4452\":\"\\\"\",\"4453\":\"d\",\"4454\":\"\\\"\",\"4455\":\",\",\"4456\":\"\\\"\",\"4457\":\"4\",\"4458\":\"3\",\"4459\":\"7\",\"4460\":\"\\\"\",\"4461\":\":\",\"4462\":\"\\\"\",\"4463\":\"-\",\"4464\":\"\\\"\",\"4465\":\",\",\"4466\":\"\\\"\",\"4467\":\"4\",\"4468\":\"3\",\"4469\":\"8\",\"4470\":\"\\\"\",\"4471\":\":\",\"4472\":\"\\\"\",\"4473\":\"6\",\"4474\":\"\\\"\",\"4475\":\",\",\"4476\":\"\\\"\",\"4477\":\"4\",\"4478\":\"3\",\"4479\":\"9\",\"4480\":\"\\\"\",\"4481\":\":\",\"4482\":\"\\\"\",\"4483\":\"2\",\"4484\":\"\\\"\",\"4485\":\",\",\"4486\":\"\\\"\",\"4487\":\"4\",\"4488\":\"4\",\"4489\":\"0\",\"4490\":\"\\\"\",\"4491\":\":\",\"4492\":\"\\\"\",\"4493\":\"f\",\"4494\":\"\\\"\",\"4495\":\",\",\"4496\":\"\\\"\",\"4497\":\"4\",\"4498\":\"4\",\"4499\":\"1\",\"4500\":\"\\\"\",\"4501\":\":\",\"4502\":\"\\\"\",\"4503\":\"b\",\"4504\":\"\\\"\",\"4505\":\",\",\"4506\":\"\\\"\",\"4507\":\"4\",\"4508\":\"4\",\"4509\":\"2\",\"4510\":\"\\\"\",\"4511\":\":\",\"4512\":\"\\\"\",\"4513\":\"4\",\"4514\":\"\\\"\",\"4515\":\",\",\"4516\":\"\\\"\",\"4517\":\"4\",\"4518\":\"4\",\"4519\":\"3\",\"4520\":\"\\\"\",\"4521\":\":\",\"4522\":\"\\\"\",\"4523\":\"1\",\"4524\":\"\\\"\",\"4525\":\",\",\"4526\":\"\\\"\",\"4527\":\"4\",\"4528\":\"4\",\"4529\":\"4\",\"4530\":\"\\\"\",\"4531\":\":\",\"4532\":\"\\\"\",\"4533\":\"0\",\"4534\":\"\\\"\",\"4535\":\",\",\"4536\":\"\\\"\",\"4537\":\"4\",\"4538\":\"4\",\"4539\":\"5\",\"4540\":\"\\\"\",\"4541\":\":\",\"4542\":\"\\\"\",\"4543\":\"d\",\"4544\":\"\\\"\",\"4545\":\",\",\"4546\":\"\\\"\",\"4547\":\"4\",\"4548\":\"4\",\"4549\":\"6\",\"4550\":\"\\\"\",\"4551\":\":\",\"4552\":\"\\\"\",\"4553\":\"4\",\"4554\":\"\\\"\",\"4555\":\",\",\"4556\":\"\\\"\",\"4557\":\"4\",\"4558\":\"4\",\"4559\":\"7\",\"4560\":\"\\\"\",\"4561\":\":\",\"4562\":\"\\\"\",\"4563\":\"b\",\"4564\":\"\\\"\",\"4565\":\",\",\"4566\":\"\\\"\",\"4567\":\"4\",\"4568\":\"4\",\"4569\":\"8\",\"4570\":\"\\\"\",\"4571\":\":\",\"4572\":\"\\\"\",\"4573\":\"0\",\"4574\":\"\\\"\",\"4575\":\",\",\"4576\":\"\\\"\",\"4577\":\"4\",\"4578\":\"4\",\"4579\":\"9\",\"4580\":\"\\\"\",\"4581\":\":\",\"4582\":\"\\\"\",\"4583\":\"5\",\"4584\":\"\\\"\",\"4585\":\",\",\"4586\":\"\\\"\",\"4587\":\"4\",\"4588\":\"5\",\"4589\":\"0\",\"4590\":\"\\\"\",\"4591\":\":\",\"4592\":\"\\\"\",\"4593\":\"\\\\\",\"4594\":\"\\\"\",\"4595\":\"\\\"\",\"4596\":\",\",\"4597\":\"\\\"\",\"4598\":\"4\",\"4599\":\"5\",\"4600\":\"1\",\"4601\":\"\\\"\",\"4602\":\":\",\"4603\":\"\\\"\",\"4604\":\"}\",\"4605\":\"\\\"\",\"4606\":\",\",\"4607\":\"\\\"\",\"4608\":\"w\",\"4609\":\"i\",\"4610\":\"d\",\"4611\":\"g\",\"4612\":\"e\",\"4613\":\"t\",\"4614\":\"C\",\"4615\":\"h\",\"4616\":\"a\",\"4617\":\"n\",\"4618\":\"n\",\"4619\":\"e\",\"4620\":\"l\",\"4621\":\"I\",\"4622\":\"d\",\"4623\":\"\\\"\",\"4624\":\":\",\"4625\":\"\\\"\",\"4626\":\"8\",\"4627\":\"6\",\"4628\":\"7\",\"4629\":\"f\",\"4630\":\"3\",\"4631\":\"6\",\"4632\":\"e\",\"4633\":\"8\",\"4634\":\"-\",\"4635\":\"1\",\"4636\":\"0\",\"4637\":\"5\",\"4638\":\"5\",\"4639\":\"-\",\"4640\":\"4\",\"4641\":\"6\",\"4642\":\"8\",\"4643\":\"5\",\"4644\":\"-\",\"4645\":\"9\",\"4646\":\"a\",\"4647\":\"2\",\"4648\":\"d\",\"4649\":\"-\",\"4650\":\"6\",\"4651\":\"2\",\"4652\":\"f\",\"4653\":\"b\",\"4654\":\"4\",\"4655\":\"1\",\"4656\":\"0\",\"4657\":\"d\",\"4658\":\"4\",\"4659\":\"b\",\"4660\":\"0\",\"4661\":\"5\",\"4662\":\"\\\"\",\"4663\":\"}\",\"widgetChannelId\":\"867f36e8-1055-4685-9a2d-62fb410d4b05\"}', '2026-10-20 08:57:48.194', '2026-10-24 16:10:58.470');
INSERT INTO `workspaces` (`id`, `name`, `slug`, `owner_user_id`, `plan`, `status`, `settings`, `created_at`, `updated_at`) VALUES
('ws-1', 'Test Workspace 1', 'test-workspace-1', 'user-1', 'free', 'active', '{\"timezone\": \"Asia/Kolkata\", \"locale\": \"en-IN\"}', '2026-10-29 14:33:00.267', '2026-10-29 14:33:00.267'),
('ws-2', 'Test Workspace 2', 'test-workspace-2', 'user-2', 'starter', 'active', '{\"timezone\": \"UTC\", \"locale\": \"en-US\"}', '2026-10-29 14:33:00.267', '2026-10-29 14:33:00.267'),
('ws-3', 'Test Workspace 3', 'test-workspace-3', 'user-3', 'pro', 'active', '{\"timezone\": \"Europe/London\", \"locale\": \"en-GB\"}', '2026-10-29 14:33:00.267', '2026-10-29 14:33:00.267');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `agents`
--
ALTER TABLE `agents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_agent_slug` (`workspace_id`,`slug`),
  ADD KEY `idx_agent_ws_status` (`workspace_id`,`status`);

--
-- Indexes for table `agent_tools`
--
ALTER TABLE `agent_tools`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_agent_tool` (`agent_id`,`tool_key`),
  ADD KEY `idx_agent_tool_ws` (`workspace_id`);

--
-- Indexes for table `agent_versions`
--
ALTER TABLE `agent_versions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_agent_version` (`agent_id`,`version`);

--
-- Indexes for table `api_keys`
--
ALTER TABLE `api_keys`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_api_key_hash` (`key_hash`),
  ADD KEY `idx_api_key_ws` (`workspace_id`);

--
-- Indexes for table `audit_events`
--
ALTER TABLE `audit_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_audit_ws_created` (`workspace_id`,`created_at`),
  ADD KEY `idx_audit_actor` (`actor_user_id`,`created_at`),
  ADD KEY `idx_audit_resource` (`resource_type`,`resource_id`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_booking_external` (`workspace_id`,`external_id`),
  ADD KEY `idx_booking_ws_start` (`workspace_id`,`start_at`),
  ADD KEY `idx_booking_contact` (`contact_id`),
  ADD KEY `fk_booking_slot` (`slot_id`),
  ADD KEY `fk_booking_service` (`service_id`);

--
-- Indexes for table `booking_services`
--
ALTER TABLE `booking_services`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_service_ws` (`workspace_id`,`active`);

--
-- Indexes for table `booking_slots`
--
ALTER TABLE `booking_slots`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_slot` (`service_id`,`start_at`),
  ADD KEY `idx_slot_ws_start` (`workspace_id`,`start_at`);

--
-- Indexes for table `campaigns`
--
ALTER TABLE `campaigns`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_campaign_ws_status` (`workspace_id`,`status`,`created_at`),
  ADD KEY `fk_campaign_template` (`template_id`);

--
-- Indexes for table `campaign_recipients`
--
ALTER TABLE `campaign_recipients`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_recipient_idem` (`idempotency_key`),
  ADD KEY `idx_recipient_campaign` (`campaign_id`,`status`),
  ADD KEY `idx_recipient_ws` (`workspace_id`);

--
-- Indexes for table `channels`
--
ALTER TABLE `channels`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_channel_ws` (`workspace_id`,`type`),
  ADD KEY `fk_channel_agent` (`agent_id`);

--
-- Indexes for table `channel_credentials`
--
ALTER TABLE `channel_credentials`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_channel_credential` (`channel_id`);

--
-- Indexes for table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_contact_phone` (`workspace_id`,`phone`),
  ADD UNIQUE KEY `uq_contact_email` (`workspace_id`,`email`),
  ADD KEY `idx_contact_ws_name` (`workspace_id`,`name`),
  ADD KEY `idx_contact_ws_source` (`workspace_id`,`source`);

--
-- Indexes for table `conversations`
--
ALTER TABLE `conversations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_conv_ws_status` (`workspace_id`,`status`,`last_message_at`),
  ADD KEY `idx_conv_ws_channel` (`workspace_id`,`channel_id`,`last_message_at`),
  ADD KEY `idx_conv_contact` (`contact_id`),
  ADD KEY `idx_conv_assignee` (`assigned_to`,`status`),
  ADD KEY `fk_conv_channel` (`channel_id`),
  ADD KEY `fk_conv_agent` (`agent_id`);

--
-- Indexes for table `customer_accounts`
--
ALTER TABLE `customer_accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_customer_account_ws_id` (`workspace_id`,`id`),
  ADD UNIQUE KEY `uq_customer_account_email` (`workspace_id`,`email`),
  ADD UNIQUE KEY `uq_customer_account_contact` (`workspace_id`,`contact_id`),
  ADD KEY `idx_customer_account_ws_created` (`workspace_id`,`created_at`);

--
-- Indexes for table `customer_sessions`
--
ALTER TABLE `customer_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_customer_session_token` (`token_hash`),
  ADD KEY `idx_customer_session_account` (`workspace_id`,`customer_account_id`,`revoked_at`);

--
-- Indexes for table `data_requests`
--
ALTER TABLE `data_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_data_req_ws` (`workspace_id`,`created_at`);

--
-- Indexes for table `delivery_attempts`
--
ALTER TABLE `delivery_attempts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_delivery_msg` (`message_id`,`created_at`),
  ADD KEY `idx_delivery_recipient` (`campaign_recipient_id`,`created_at`),
  ADD KEY `idx_delivery_ws` (`workspace_id`,`created_at`);

--
-- Indexes for table `flows`
--
ALTER TABLE `flows`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_flow_ws` (`workspace_id`,`status`);

--
-- Indexes for table `flow_runs`
--
ALTER TABLE `flow_runs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_run_ws_status` (`workspace_id`,`status`,`wait_until`),
  ADD KEY `idx_run_conv` (`conversation_id`),
  ADD KEY `idx_run_flow` (`flow_id`,`started_at`);

--
-- Indexes for table `flow_steps`
--
ALTER TABLE `flow_steps`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_step_run` (`run_id`,`started_at`);

--
-- Indexes for table `flow_versions`
--
ALTER TABLE `flow_versions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_flow_version` (`flow_id`,`version`);

--
-- Indexes for table `handoffs`
--
ALTER TABLE `handoffs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_handoff_conv` (`conversation_id`,`created_at`),
  ADD KEY `idx_handoff_user` (`to_user_id`,`status`);

--
-- Indexes for table `idempotency_keys`
--
ALTER TABLE `idempotency_keys`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_idem` (`workspace_id`,`scope`,`idem_key`);

--
-- Indexes for table `industry_templates`
--
ALTER TABLE `industry_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `industry` (`industry`);

--
-- Indexes for table `ingestion_jobs`
--
ALTER TABLE `ingestion_jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ingest_ws` (`workspace_id`,`status`,`created_at`),
  ADD KEY `idx_ingest_source` (`source_id`,`created_at`);

--
-- Indexes for table `invitations`
--
ALTER TABLE `invitations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_invitation_token` (`token_hash`),
  ADD KEY `idx_invitation_ws_email` (`workspace_id`,`email`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_job_dedupe` (`queue`,`dedupe_key`),
  ADD KEY `idx_jobs_claim` (`queue`,`status`,`run_at`,`priority`),
  ADD KEY `idx_jobs_status_updated` (`status`,`updated_at`);

--
-- Indexes for table `knowledge_chunks`
--
ALTER TABLE `knowledge_chunks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_chunk` (`source_id`,`chunk_index`),
  ADD KEY `idx_chunk_ws` (`workspace_id`,`source_id`);
ALTER TABLE `knowledge_chunks` ADD FULLTEXT KEY `ft_chunk_content` (`content`);

--
-- Indexes for table `knowledge_sources`
--
ALTER TABLE `knowledge_sources`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_knowledge_ws_status` (`workspace_id`,`status`,`updated_at`);

--
-- Indexes for table `leads`
--
ALTER TABLE `leads`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_lead_external` (`workspace_id`,`source`,`external_enquiry_id`),
  ADD KEY `idx_lead_ws_status` (`workspace_id`,`status`,`created_at`),
  ADD KEY `idx_lead_owner` (`owner_user_id`,`status`),
  ADD KEY `idx_lead_followup` (`workspace_id`,`follow_up_at`),
  ADD KEY `fk_lead_contact` (`contact_id`);

--
-- Indexes for table `lead_stage_history`
--
ALTER TABLE `lead_stage_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_lead_stage` (`lead_id`,`created_at`);

--
-- Indexes for table `marketplace_cursors`
--
ALTER TABLE `marketplace_cursors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_mkt_channel` (`channel_id`);

--
-- Indexes for table `memberships`
--
ALTER TABLE `memberships`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_membership` (`workspace_id`,`user_id`),
  ADD KEY `idx_memberships_user` (`user_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_message_dedupe` (`workspace_id`,`dedupe_key`),
  ADD KEY `idx_message_conv_created` (`conversation_id`,`created_at`),
  ADD KEY `idx_message_ws_created` (`workspace_id`,`created_at`);

--
-- Indexes for table `message_attachments`
--
ALTER TABLE `message_attachments`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `idx_message_attachment_workspace` (`workspace_id`,`created_at`),
  ADD KEY `fk_message_attachment_source` (`source_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_order_number` (`workspace_id`,`order_number`),
  ADD UNIQUE KEY `uq_order_external` (`workspace_id`,`external_ref`),
  ADD KEY `idx_order_ws_status` (`workspace_id`,`status`,`created_at`),
  ADD KEY `idx_order_contact` (`contact_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order_item` (`order_id`);

--
-- Indexes for table `order_status_history`
--
ALTER TABLE `order_status_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order_history` (`order_id`,`created_at`);

--
-- Indexes for table `outbox_events`
--
ALTER TABLE `outbox_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_outbox_pending` (`status`,`available_at`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_reset_token` (`token_hash`),
  ADD KEY `idx_reset_user` (`user_id`);

--
-- Indexes for table `refresh_sessions`
--
ALTER TABLE `refresh_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_refresh_token` (`token_hash`),
  ADD KEY `idx_refresh_user` (`user_id`,`revoked_at`);

--
-- Indexes for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`role`,`permission`);

--
-- Indexes for table `schema_migrations`
--
ALTER TABLE `schema_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ticket_ws_status` (`workspace_id`,`status`,`created_at`),
  ADD KEY `idx_ticket_assignee` (`assigned_to`,`status`);

--
-- Indexes for table `templates`
--
ALTER TABLE `templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_template` (`workspace_id`,`channel_type`,`name`,`language`),
  ADD KEY `idx_template_ws` (`workspace_id`,`channel_type`);

--
-- Indexes for table `ticket_events`
--
ALTER TABLE `ticket_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ticket_event` (`ticket_id`,`created_at`);

--
-- Indexes for table `ticket_notes`
--
ALTER TABLE `ticket_notes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ticket_note` (`ticket_id`,`created_at`);

--
-- Indexes for table `tool_executions`
--
ALTER TABLE `tool_executions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_tool_ws` (`workspace_id`,`created_at`),
  ADD KEY `idx_tool_conv` (`conversation_id`);

--
-- Indexes for table `usage_events`
--
ALTER TABLE `usage_events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_usage_ws_created` (`workspace_id`,`created_at`),
  ADD KEY `idx_usage_kind` (`workspace_id`,`kind`,`created_at`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_users_email` (`email`);

--
-- Indexes for table `user_whatsapp_verifications`
--
ALTER TABLE `user_whatsapp_verifications`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `webhook_events`
--
ALTER TABLE `webhook_events`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_webhook_event` (`provider`,`external_event_id`),
  ADD KEY `idx_webhook_ws_status` (`workspace_id`,`status`,`received_at`);

--
-- Indexes for table `widget_sessions`
--
ALTER TABLE `widget_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_widget_visitor` (`channel_id`,`visitor_id`),
  ADD KEY `idx_widget_ws` (`workspace_id`);

--
-- Indexes for table `workspaces`
--
ALTER TABLE `workspaces`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_workspaces_slug` (`slug`),
  ADD KEY `idx_workspaces_owner` (`owner_user_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `agents`
--
ALTER TABLE `agents`
  ADD CONSTRAINT `fk_agent_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `agent_tools`
--
ALTER TABLE `agent_tools`
  ADD CONSTRAINT `fk_agent_tool_agent` FOREIGN KEY (`agent_id`) REFERENCES `agents` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `agent_versions`
--
ALTER TABLE `agent_versions`
  ADD CONSTRAINT `fk_agent_version_agent` FOREIGN KEY (`agent_id`) REFERENCES `agents` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `api_keys`
--
ALTER TABLE `api_keys`
  ADD CONSTRAINT `fk_api_key_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_booking_service` FOREIGN KEY (`service_id`) REFERENCES `booking_services` (`id`),
  ADD CONSTRAINT `fk_booking_slot` FOREIGN KEY (`slot_id`) REFERENCES `booking_slots` (`id`),
  ADD CONSTRAINT `fk_booking_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_services`
--
ALTER TABLE `booking_services`
  ADD CONSTRAINT `fk_service_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_slots`
--
ALTER TABLE `booking_slots`
  ADD CONSTRAINT `fk_slot_service` FOREIGN KEY (`service_id`) REFERENCES `booking_services` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `campaigns`
--
ALTER TABLE `campaigns`
  ADD CONSTRAINT `fk_campaign_template` FOREIGN KEY (`template_id`) REFERENCES `templates` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_campaign_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `campaign_recipients`
--
ALTER TABLE `campaign_recipients`
  ADD CONSTRAINT `fk_recipient_campaign` FOREIGN KEY (`campaign_id`) REFERENCES `campaigns` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `channels`
--
ALTER TABLE `channels`
  ADD CONSTRAINT `fk_channel_agent` FOREIGN KEY (`agent_id`) REFERENCES `agents` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_channel_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `channel_credentials`
--
ALTER TABLE `channel_credentials`
  ADD CONSTRAINT `fk_cred_channel` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `contacts`
--
ALTER TABLE `contacts`
  ADD CONSTRAINT `fk_contact_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `conversations`
--
ALTER TABLE `conversations`
  ADD CONSTRAINT `fk_conv_agent` FOREIGN KEY (`agent_id`) REFERENCES `agents` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_conv_channel` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_conv_contact` FOREIGN KEY (`contact_id`) REFERENCES `contacts` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_conv_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `customer_accounts`
--
ALTER TABLE `customer_accounts`
  ADD CONSTRAINT `fk_customer_account_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `customer_sessions`
--
ALTER TABLE `customer_sessions`
  ADD CONSTRAINT `fk_customer_session_account` FOREIGN KEY (`workspace_id`,`customer_account_id`) REFERENCES `customer_accounts` (`workspace_id`, `id`) ON DELETE CASCADE;

--
-- Constraints for table `data_requests`
--
ALTER TABLE `data_requests`
  ADD CONSTRAINT `fk_data_req_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `flows`
--
ALTER TABLE `flows`
  ADD CONSTRAINT `fk_flow_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `flow_runs`
--
ALTER TABLE `flow_runs`
  ADD CONSTRAINT `fk_run_flow` FOREIGN KEY (`flow_id`) REFERENCES `flows` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `flow_steps`
--
ALTER TABLE `flow_steps`
  ADD CONSTRAINT `fk_step_run` FOREIGN KEY (`run_id`) REFERENCES `flow_runs` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `flow_versions`
--
ALTER TABLE `flow_versions`
  ADD CONSTRAINT `fk_flow_version_flow` FOREIGN KEY (`flow_id`) REFERENCES `flows` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `handoffs`
--
ALTER TABLE `handoffs`
  ADD CONSTRAINT `fk_handoff_conv` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ingestion_jobs`
--
ALTER TABLE `ingestion_jobs`
  ADD CONSTRAINT `fk_ingest_source` FOREIGN KEY (`source_id`) REFERENCES `knowledge_sources` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `invitations`
--
ALTER TABLE `invitations`
  ADD CONSTRAINT `fk_invitation_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `knowledge_chunks`
--
ALTER TABLE `knowledge_chunks`
  ADD CONSTRAINT `fk_chunk_source` FOREIGN KEY (`source_id`) REFERENCES `knowledge_sources` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `knowledge_sources`
--
ALTER TABLE `knowledge_sources`
  ADD CONSTRAINT `fk_knowledge_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `leads`
--
ALTER TABLE `leads`
  ADD CONSTRAINT `fk_lead_contact` FOREIGN KEY (`contact_id`) REFERENCES `contacts` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_lead_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `lead_stage_history`
--
ALTER TABLE `lead_stage_history`
  ADD CONSTRAINT `fk_lead_stage_lead` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `marketplace_cursors`
--
ALTER TABLE `marketplace_cursors`
  ADD CONSTRAINT `fk_mkt_channel` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `memberships`
--
ALTER TABLE `memberships`
  ADD CONSTRAINT `fk_memberships_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_memberships_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `fk_message_conv` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_message_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `message_attachments`
--
ALTER TABLE `message_attachments`
  ADD CONSTRAINT `fk_message_attachment_message` FOREIGN KEY (`message_id`) REFERENCES `messages` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_message_attachment_source` FOREIGN KEY (`source_id`) REFERENCES `knowledge_sources` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_message_attachment_workspace` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_order_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_order_item_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_status_history`
--
ALTER TABLE `order_status_history`
  ADD CONSTRAINT `fk_order_history_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD CONSTRAINT `fk_reset_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `refresh_sessions`
--
ALTER TABLE `refresh_sessions`
  ADD CONSTRAINT `fk_refresh_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `support_tickets`
--
ALTER TABLE `support_tickets`
  ADD CONSTRAINT `fk_ticket_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `templates`
--
ALTER TABLE `templates`
  ADD CONSTRAINT `fk_template_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ticket_events`
--
ALTER TABLE `ticket_events`
  ADD CONSTRAINT `fk_ticket_event_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `support_tickets` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ticket_notes`
--
ALTER TABLE `ticket_notes`
  ADD CONSTRAINT `fk_ticket_note_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `support_tickets` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `usage_events`
--
ALTER TABLE `usage_events`
  ADD CONSTRAINT `fk_usage_ws` FOREIGN KEY (`workspace_id`) REFERENCES `workspaces` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_whatsapp_verifications`
--
ALTER TABLE `user_whatsapp_verifications`
  ADD CONSTRAINT `fk_user_whatsapp_verification_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `widget_sessions`
--
ALTER TABLE `widget_sessions`
  ADD CONSTRAINT `fk_widget_channel` FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `workspaces`
--
ALTER TABLE `workspaces`
  ADD CONSTRAINT `fk_workspaces_owner` FOREIGN KEY (`owner_user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
