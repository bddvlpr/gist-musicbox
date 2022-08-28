const createStarBar = (value: number, maxValue: number, maxStars = 6) => {
  const filledStars = Math.ceil((value / maxValue) * maxStars);
  return "★".repeat(filledStars) + "☆".repeat(maxStars - filledStars);
};

export { createStarBar };
