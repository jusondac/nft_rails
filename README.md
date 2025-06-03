# NFT Trials - Digital Art NFT Simulation Platform
![Screenshot From 2025-06-03 11-14-41](https://github.com/user-attachments/assets/50e16fb2-4da2-4441-b700-e127debc2ea4)

NFT Trials is a Ruby on Rails application that simulates the process of minting digital artwork as NFTs (Non-Fungible Tokens). This platform allows users to upload digital images and experience a realistic NFT minting workflow without actually interacting with real blockchain networks.

## Features

### Core Functionality
- **User Authentication**: Secure user registration and login system with bcrypt password encryption
- **Digital Art Upload**: Users can upload images that will be converted into simulated NFTs
- **NFT Simulation**: Complete simulation of the blockchain minting process
- **NFT Collection Management**: Users can view and manage their minted NFTs
- **Post Management**: Create, edit, and delete art posts (restrictions apply for minted content)

### NFT Simulation Explained

The NFT simulation system provides a realistic experience of the blockchain minting process without requiring actual cryptocurrency or blockchain transactions. Here's how it works:

#### 1. Post Creation & Upload
- Users upload digital artwork with title and description
- Images are stored using Rails Active Storage
- Posts start with "pending" status, ready for minting

#### 2. Automated Minting Process
- **Background Job Processing**: Upon post creation, a `MintNftJob` is automatically queued
- **Validation**: The system validates that the post has an attached image and is in "pending" status
- **Status Updates**: Post status progresses through: `pending` → `minting` → `minted` (or `failed`)

#### 3. NFT Metadata Generation
The system automatically generates comprehensive NFT metadata including:
- **Basic Info**: Name, description, image URL
- **Attributes**: Creator name, creation date, file type
- **Creator Details**: User information and email
- **Timestamps**: ISO8601 formatted creation time

#### 4. Simulated Blockchain Interaction
- **Mock Token Generation**: Creates realistic token IDs using timestamp + NFT ID + random numbers
- **Contract Address**: Simulates Ethereum contract addresses
- **Transaction Simulation**: Generates mock transaction hashes
- **Network Simulation**: Defaults to Ethereum blockchain simulation

#### 5. NFT Record Creation
- Creates permanent NFT records linked to users
- Stores metadata as JSON
- Tracks minting timestamps and blockchain details
- Maintains relationships between posts and NFTs

### Technical Architecture

#### Models
- **User**: Manages user accounts with secure authentication
- **Post**: Handles artwork uploads and minting workflow
- **NFT**: Stores minted NFT data and metadata

#### Services
- **NftMintingService**: Core service handling the complete minting simulation process
  - Validates posts and images
  - Generates NFT metadata
  - Simulates blockchain interactions
  - Creates NFT records
  - Handles error scenarios

#### Background Jobs
- **MintNftJob**: Asynchronous job for processing NFT minting
  - Retry mechanism (3 attempts with 30-second delays)
  - Error logging and handling
  - Integration with Rails logging system

#### Controllers
- **PostsController**: Manages artwork posting and editing
- **NftsController**: Handles NFT viewing and collection management
- **HomeController**: Dashboard with user statistics
- **UsersController**: User registration and profile management

### Database Schema

#### Users Table
- Email (unique), password_digest, name
- Timestamps for creation and updates

#### Posts Table
- User association, title, description
- NFT association (optional, set after minting)
- Status tracking (pending, minting, minted, failed)
- Active Storage image attachment

#### NFTs Table
- User association, token_id (unique per user)
- Metadata (JSON), blockchain type
- Contract address, minting timestamp
- Title, description, and various blockchain-specific fields

## Getting Started

### Prerequisites
- Ruby 3.1+ 
- Rails 8.0+
- SQLite3 (development)
- Node.js (for asset pipeline)

### System Dependencies
- **bcrypt**: Password encryption
- **httparty**: HTTP requests (for future blockchain integration)
- **tailwindcss-rails**: Modern CSS framework
- **stimulus-rails**: JavaScript framework
- **turbo-rails**: SPA-like page acceleration
- **solid_queue**: Background job processing
- **solid_cache**: Database-backed caching

### Installation & Setup

1. **Clone the repository**
   ```bash
   git clone [repository-url]
   cd nftrials
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Database setup**
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed
   ```

4. **Start the development server**
   ```bash
   bin/dev
   ```

5. **Access the application**
   - Open http://localhost:3000
   - Register a new account or use demo credentials

### Demo Data
The seed file creates demo users with sample data:
- **alice@example.com** / password123
- **bob@example.com** / password123  
- **charlie@example.com** / password123

### Development Tools
- **Brakeman**: Security vulnerability scanner
- **RuboCop**: Ruby code style checker
- **Rails Console**: `bin/rails console`
- **Background Jobs**: Processed automatically via Solid Queue

## Usage Workflow

1. **Register/Login**: Create account or sign in
2. **Upload Artwork**: Create new post with image and metadata
3. **Automatic Minting**: System processes NFT minting in background
4. **View Collection**: Browse your minted NFTs with full metadata
5. **Manage Content**: Edit posts (before minting) or view NFT details

## Future Enhancements

The simulation system is designed for easy integration with real blockchain services:
- **OpenSea API**: Direct marketplace integration
- **Moralis**: Web3 development platform
- **Alchemy**: Blockchain infrastructure
- **Web3 Libraries**: Direct blockchain interaction
- **IPFS**: Decentralized metadata storage

## Technical Notes

- **Security**: Implements proper authentication and authorization
- **Performance**: Uses background jobs for time-intensive operations
- **Scalability**: Database-backed caching and job processing
- **Error Handling**: Comprehensive error logging and user feedback
- **Image Processing**: Active Storage for file management
- **Modern UI**: Tailwind CSS for responsive design
