# Algorithmic Stablecoin Lite

This repository provides a professional implementation of a decentralized, non-collateralized stablecoin system. It mimics the mechanics of protocols like Basis Cash or Terra (pre-V2), using an on-chain "Treasury" to manage the supply based on oracle price feeds.

## The Three-Token System
1. **Stable Token ($CASH):** The asset intended to be pegged to $1.00.
2. **Share Token ($SHARE):** Receives seigniorage (newly minted $CASH) when the price is above the peg.
3. **Bond Token ($BOND):** Sold at a discount when the price is below the peg to contract the supply.



## Monetary Policy
* **Expansion:** If $CASH > $1.05, the Treasury mints new $CASH and distributes it to $SHARE stakers.
* **Contraction:** If $CASH < $0.95, the Treasury allows users to burn $CASH in exchange for $BONDs, which can be redeemed for $CASH + premium when the peg restores.

## Security & Logic
* **Epoch-Based:** Rebases/supply adjustments happen once every 24 hours (Epoch).
* **Oracle Dependent:** Requires a reliable Price Feed (e.g., Chainlink) to determine the current peg deviation.

## License
MIT
