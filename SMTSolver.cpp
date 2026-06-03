#include "bits/stdc++.h"
#define int long long
#define pb push_back
using namespace std;
// ===================================END Of the input module
// ==========================================

struct Constraint {
  int score;
  vector<char> colors;
};

signed main() {
  ios_base::sync_with_stdio(0);
  cin.tie(0);
  // solver for SMT problems with 5 colors and 5 positions.

  ios_base::sync_with_stdio(false);
  cin.tie(NULL);

  vector<Constraint> constraints;
  string line;
  string unique_colors = "";

  // parse input (format as # correct then colors, so 0YRBGP)
  while (getline(cin, line)) {
    if (line.empty())
      continue;

    stringstream ss(line);
    Constraint c;
    ss >> c.score;

    char color;
    while (ss >> color) {
      c.colors.pb(color);

      // Track the unique colors used in this puzzle
      if (unique_colors.find(color) == string::npos) {
        unique_colors += color;
      }
    }
    constraints.pb(c);
  }

  if (unique_colors.length() != 5) {
    cout << "Error: Expected exactly 5 unique colors, found "
         << unique_colors.length() << ".\n";
    return 1;
  }

  // next_permutation requires the string to be sorted initially
  sort(unique_colors.begin(), unique_colors.end());
  bool found = false;

  // iterate through all 120 possible permutations
  do {
    bool valid = true;
    for (const auto &c : constraints) {
      int matches = 0;
      for (int i = 0; i < 5; ++i) {
        if (unique_colors[i] == c.colors[i]) {
          matches++;
        }
      }

      // if the current permutation doesn't perfectly match the score, prune it
      if (matches != c.score) {
        valid = false;
        break;
      }
    }

    if (valid) {
      for (char color : unique_colors) {
        cout << color << " ";
      }
      found = true;
      break;
    }
  } while (next_permutation(unique_colors.begin(), unique_colors.end()));

  if (!found) {
    cout << "No valid permutation found. Check constraints.\n";
  }

  return 0;
}