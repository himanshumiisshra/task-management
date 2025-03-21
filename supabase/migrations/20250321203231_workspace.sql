-- Create workspaces table
CREATE TABLE IF NOT EXISTS workspaces (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY NOT NULL,  -- 'id' as UUID with default random generation
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,  -- 'created_at' with timezone and default now
  workspace_owner UUID NOT NULL,  -- 'workspace_owner' as UUID, not null
  title TEXT NOT NULL,  -- 'title' as text, not null
  icon_id TEXT NOT NULL,  -- 'icon_id' as text, not null
  data TEXT,  -- 'data' as text (nullable)
  in_trash TEXT,  -- 'in_trash' as text (nullable)
  logo TEXT,  -- 'logo' as text (nullable)
  banner_url TEXT  -- 'banner_url' as text (nullable)
);

-- Insert sample data into workspaces
INSERT INTO workspaces (workspace_owner, title, icon_id, data, in_trash, logo, banner_url)
VALUES ('550e8400-e29b-41d4-a716-446655440000', 'Sample Title', '1', '{}', 'false', 'logo_url', 'banner_url');

-- Create folders table
CREATE TABLE IF NOT EXISTS folders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY NOT NULL,  -- 'id' as UUID with default random generation
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,  -- 'created_at' with default now
  title TEXT NOT NULL,  -- 'title' as text, not null
  icon_id TEXT NOT NULL,  -- 'icon_id' as text, not null
  data TEXT,  -- 'data' as text (nullable)
  in_trash TEXT,  -- 'in_trash' as text (nullable)
  banner_url TEXT,  -- 'banner_url' as text (nullable)
  workspace_id UUID NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE  -- Foreign key to workspaces
);

-- Insert sample data into folders
INSERT INTO folders (title, icon_id, data, in_trash, banner_url, workspace_id)
VALUES ('Sample Folder', '2', '{}', 'false', 'banner_url', '550e8400-e29b-41d4-a716-446655440000');

-- Create files table
CREATE TABLE IF NOT EXISTS files (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY NOT NULL,  -- 'id' as UUID with default random generation
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,  -- 'created_at' with default now
  title TEXT NOT NULL,  -- 'title' as text, not null
  icon_id TEXT NOT NULL,  -- 'icon_id' as text, not null
  data TEXT,  -- 'data' as text (nullable)
  in_trash TEXT,  -- 'in_trash' as text (nullable)
  banner_url TEXT,  -- 'banner_url' as text (nullable)
  workspace_id UUID NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,  -- Foreign key to workspaces
  folder_id UUID NOT NULL REFERENCES folders(id) ON DELETE CASCADE  -- Foreign key to folders
);

-- Insert sample data into files
INSERT INTO files (title, icon_id, data, in_trash, banner_url, workspace_id, folder_id)
VALUES ('Sample File', '3', '{}', 'false', 'banner_url', '550e8400-e29b-41d4-a716-446655440000', '550e8400-e29b-41d4-a716-446655440000');

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY NOT NULL,  -- 'id' as UUID primary key
  full_name TEXT,  -- 'full_name' as text (nullable)
  avatar_url TEXT,  -- 'avatar_url' as text (nullable)
  billing_address JSONB,  -- 'billing_address' as JSONB (nullable)
  updated_at TIMESTAMP WITH TIME ZONE,  -- 'updated_at' with timezone (nullable)
  payment_method JSONB,  -- 'payment_method' as JSONB (nullable)
  email TEXT  -- 'email' as text (nullable)
);

-- Insert sample data into users
INSERT INTO users (id, full_name, avatar_url, billing_address, updated_at, payment_method, email)
VALUES ('550e8400-e29b-41d4-a716-446655440000', 'John Doe', 'avatar_url', '{}', NOW(), '{}', 'john@example.com');

-- Create customers table
CREATE TABLE IF NOT EXISTS customers (
  id UUID PRIMARY KEY NOT NULL,  -- 'id' as UUID primary key
  stripe_customer_id TEXT  -- 'stripe_customer_id' as text (nullable)
);

-- Insert sample data into customers
INSERT INTO customers (id, stripe_customer_id)
VALUES ('550e8400-e29b-41d4-a716-446655440000', 'cus_123456789');

-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id TEXT PRIMARY KEY NOT NULL,  -- 'id' as text primary key
  active BOOLEAN,  -- 'active' as boolean (nullable)
  name TEXT,  -- 'name' as text (nullable)
  description TEXT,  -- 'description' as text (nullable)
  image TEXT,  -- 'image' as text (nullable)
  metadata JSONB  -- 'metadata' as JSONB (nullable)
);

-- Create prices table
CREATE TABLE IF NOT EXISTS prices (
  id TEXT PRIMARY KEY NOT NULL,  -- 'id' as text primary key
  product_id TEXT REFERENCES products(id),  -- Foreign key to products
  active BOOLEAN,  -- 'active' as boolean (nullable)
  description TEXT,  -- 'description' as text (nullable)
  unit_amount BIGINT,  -- 'unit_amount' as big integer
  currency TEXT,  -- 'currency' as text (nullable)
  type TEXT,  -- 'type' as text (nullable)
  interval TEXT,  -- 'interval' as text (nullable)
  interval_count INTEGER,  -- 'interval_count' as integer (nullable)
  trial_period_days INTEGER,  -- 'trial_period_days' as integer (nullable)
  metadata JSONB  -- 'metadata' as JSONB (nullable)
);

-- Create subscriptions table
CREATE TABLE IF NOT EXISTS subscriptions (
  id TEXT PRIMARY KEY NOT NULL,  -- 'id' as text primary key
  user_id UUID NOT NULL,  -- 'user_id' as UUID, not null
  status TEXT,  -- 'status' as text (nullable)
  metadata JSONB,  -- 'metadata' as JSONB (nullable)
  price_id TEXT REFERENCES prices(id),  -- Foreign key to prices
  quantity INTEGER,  -- 'quantity' as integer (nullable)
  cancel_at_period_end BOOLEAN,  -- 'cancel_at_period_end' as boolean (nullable)
  created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,  -- 'created' timestamp
  current_period_start TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,  -- 'current_period_start' timestamp
  current_period_end TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,  -- 'current_period_end' timestamp
  ended_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,  -- 'ended_at' timestamp (nullable)
  cancel_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,  -- 'cancel_at' timestamp (nullable)
  canceled_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,  -- 'canceled_at' timestamp (nullable)
  trial_start TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,  -- 'trial_start' timestamp (nullable)
  trial_end TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP  -- 'trial_end' timestamp (nullable)
);

-- Create collaborators table
CREATE TABLE IF NOT EXISTS collaborators (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY NOT NULL,  -- 'id' as UUID primary key
  workspace_id UUID NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,  -- Foreign key to workspaces
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,  -- 'created_at' timestamp
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE  -- Foreign key to users
);
