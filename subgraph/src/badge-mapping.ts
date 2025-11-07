import { BadgeMinted } from "../generated/SimpleZKBadge/SimpleZKBadge"
import { Badge, User, GlobalStats } from "../generated/schema"

export function handleBadgeMinted(event: BadgeMinted): void {
  // Create Badge entity
  let badge = new Badge(event.params.tokenId.toString())
  badge.tokenId = event.params.tokenId
  badge.owner = event.params.recipient
  badge.badgeType = event.params.badgeType
  badge.zkProofHash = event.params.zkProofHash
  badge.issuedAt = event.block.timestamp
  badge.txHash = event.transaction.hash
  badge.save()

  // Update or create User
  let user = User.load(event.params.recipient.toHexString())
  if (user == null) {
    user = new User(event.params.recipient.toHexString())
    user.address = event.params.recipient
    user.totalBadges = BigInt.fromI32(0)
    user.createdAt = event.block.timestamp
  }
  user.totalBadges = user.totalBadges.plus(BigInt.fromI32(1))
  user.save()

  // Update Global Stats
  let stats = GlobalStats.load("global")
  if (stats == null) {
    stats = new GlobalStats("global")
    stats.totalBadges = BigInt.fromI32(0)
    stats.totalPassports = BigInt.fromI32(0)
    stats.totalUsers = BigInt.fromI32(0)
    stats.averageCreditScore = BigInt.fromI32(0)
  }
  stats.totalBadges = stats.totalBadges.plus(BigInt.fromI32(1))
  stats.save()
}
