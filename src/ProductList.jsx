import { useCallback, useEffect, useRef, useState } from "react";
import { FixedSizeList } from "react-window";

const API_URL = "http://localhost:8080/api/products/cursor";
const PAGE_SIZE = 40;
const LIST_HEIGHT = 700;
const ROW_HEIGHT = 96;

function ProductRow({ index, style, data }) {
  const product = data[index];

  return (
    <div style={style}>
      <div
        style={{
          display: "flex",
          alignItems: "center",
          gap: 16,
          padding: "12px 16px",
          boxSizing: "border-box",
          height: "100%",
          borderBottom: "1px solid #e5e7eb",
        }}
      >
        <img
          src={product.imageUrl}
          alt={product.name}
          width={64}
          height={64}
          loading="lazy"
          style={{ objectFit: "cover", borderRadius: 8 }}
        />
        <div>
          <h3 style={{ margin: 0, fontSize: 16 }}>{product.name}</h3>
          <div style={{ color: "#6b7280", fontSize: 14 }}>
            {product.category} · {product.color}
          </div>
          <div style={{ marginTop: 4, fontWeight: 600 }}>
            ₹{Number(product.price).toFixed(2)}
          </div>
        </div>
      </div>
    </div>
  );
}

export default function ProductList() {
  const [products, setProducts] = useState([]);
  const [nextCursor, setNextCursor] = useState(0);
  const [hasNext, setHasNext] = useState(true);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const loadingRef = useRef(false);

  const loadProducts = useCallback(async () => {
    if (loadingRef.current || !hasNext) return;

    loadingRef.current = true;
    setLoading(true);
    setError("");

    try {
      const response = await fetch(
        `${API_URL}?lastId=${nextCursor}&size=${PAGE_SIZE}`
      );

      if (!response.ok) {
        throw new Error(`Request failed: ${response.status}`);
      }

      const data = await response.json();

      setProducts((current) => [...current, ...data.content]);
      setNextCursor(data.nextCursor ?? nextCursor);
      setHasNext(data.hasNext);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to load products");
    } finally {
      loadingRef.current = false;
      setLoading(false);
    }
  }, [hasNext, nextCursor]);

  useEffect(() => {
    loadProducts();
  }, [loadProducts]);

  const handleItemsRendered = ({ visibleStopIndex }) => {
    if (visibleStopIndex >= products.length - 10) {
      loadProducts();
    }
  };

  return (
    <main style={{ maxWidth: 900, margin: "0 auto", padding: 24 }}>
      <header style={{ marginBottom: 20 }}>
        <h1 style={{ marginBottom: 6 }}>Products</h1>
        <p style={{ margin: 0, color: "#6b7280" }}>
          Virtualized 10k+ product catalog with cursor pagination.
        </p>
      </header>

      {error && (
        <div style={{ marginBottom: 16, color: "#b91c1c" }}>
          {error}
        </div>
      )}

      <div
        style={{
          border: "1px solid #e5e7eb",
          borderRadius: 12,
          overflow: "hidden",
        }}
      >
        <FixedSizeList
          height={LIST_HEIGHT}
          width="100%"
          itemCount={products.length}
          itemSize={ROW_HEIGHT}
          itemData={products}
          onItemsRendered={handleItemsRendered}
        >
          {ProductRow}
        </FixedSizeList>
      </div>

      <div style={{ paddingTop: 12, color: "#6b7280", fontSize: 14 }}>
        Loaded {products.length} products
        {loading ? " · Loading…" : ""}
        {!loading && !hasNext ? " · End of catalog" : ""}
      </div>
    </main>
  );
}
