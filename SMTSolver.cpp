#include "bits/stdc++.h"
#define int long long
#define uint unsigned long long
#define vi vector<int>
#define vvi vector<vi>
#define vb vector<bool>
#define vvb vector<vb>
#define pi pair<int, int>
#define F first
#define S second
#define pb push_back
#define mp make_pair
#define fr(i, n) for (int i = 0; i < (n); i++)
#define rep(i, a, n) for (int i = (a); i <= (n); i++)
#define nl "\n"
#define dbg(var) cerr << #var << "=" << var << " "
#define all(v) v.begin(), v.end()
#define srt(v) sort(v.begin(), v.end())         // sort
#define mxe(v) *max_element(v.begin(), v.end()) // find max element in vector
#define mne(v) *min_element(v.begin(), v.end()) // find min element in vector
#define unq(v) v.resize(distance(v.begin(), unique(v.begin(), v.end())));
// make sure to sort before applying unique // else only consecutive duplicates
// would be removed
#define bin(x, y) bitset<y>(x)
using namespace std;
int MOD = 1e9 + 7; // Hardcoded, directly change from here for functions!

const int MX_SZ = 1e5 + 5;
int par[MX_SZ];

void modadd(int &a, int b) { a = ((a % MOD) + (b % MOD)) % MOD; }
void modsub(int &a, int b) { a = ((a % MOD) - (b % MOD) + MOD) % MOD; }
void modmul(int &a, int b) { a = ((a % MOD) * (b % MOD)) % MOD; }
// ================================== take ip/op like vector,pairs
// directly!==================================
template <typename typC, typename typD>
istream &operator>>(istream &cin, pair<typC, typD> &a) {
  return cin >> a.first >> a.second;
}
template <typename typC> istream &operator>>(istream &cin, vector<typC> &a) {
  for (auto &x : a)
    cin >> x;
  return cin;
}
template <typename typC, typename typD>
ostream &operator<<(ostream &cout, const pair<typC, typD> &a) {
  return cout << a.first << ' ' << a.second;
}
template <typename typC, typename typD>
ostream &operator<<(ostream &cout, const vector<pair<typC, typD>> &a) {
  for (auto &x : a)
    cout << x << '\n';
  return cout;
}
template <typename typC>
ostream &operator<<(ostream &cout, const vector<typC> &a) {
  int n = a.size();
  if (!n)
    return cout;
  cout << a[0];
  for (int i = 1; i < n; i++)
    cout << ' ' << a[i];
  return cout;
}
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
      c.colors.push_back(color);

      // Track the unique colors used in this puzzle
      if (unique_colors.find(color) == string::npos) {
        unique_colors += color;
      }
    }
    constraints.push_back(c);
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
      cout << "\n";
      found = true;
      break;
    }

  } while (next_permutation(unique_colors.begin(), unique_colors.end()));

  if (!found) {
    cout << "No valid permutation found. Check constraints.\n";
  }

  return 0;

  return 0;
}