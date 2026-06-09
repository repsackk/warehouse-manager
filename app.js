// app.js
const BASE_URL = 'http://localhost/portfolio/warehouse-manager/api';
let currentUser = JSON.parse(localStorage.getItem('erp_user')) || null;
let authAction = 'login';

let localProducts = [];
let currentInvoiceItems = [];

document.addEventListener('DOMContentLoaded', () => {
    initApp();
    document.getElementById('loginForm').addEventListener('submit', handleAuth);
    document.getElementById('invoiceForm').addEventListener('submit', handleInvoiceSubmit);
    document.getElementById('editForm').addEventListener('submit', handleEditSubmit);
});

function setAuthAction(action) { authAction = action; }

function initApp() {
    if (currentUser) {
        document.getElementById('authScreen').classList.add('hidden');
        document.getElementById('mainDashboard').classList.remove('hidden');
        document.getElementById('navUser').innerText = currentUser.username;
        document.getElementById('navRole').innerText = currentUser.role;

        if (currentUser.role === 'admin') {
            document.getElementById('adminPanel').classList.remove('hidden');
            fetchUnapprovedUsers();
        } else {
            document.getElementById('adminPanel').classList.add('hidden');
        }

        fetchProducts();
    } else {
        document.getElementById('authScreen').classList.remove('hidden');
        document.getElementById('mainDashboard').classList.add('hidden');
    }
}

// ==========================================
// 1. SYSTEM AUTORYZACJI (LOGOWANIE / REJESTRACJA)
// ==========================================
async function handleAuth(e) {
    e.preventDefault();
    const username = document.getElementById('authUsername').value;
    const password = document.getElementById('authPassword').value;

    try {
        const response = await fetch(`${BASE_URL}/auth.php?action=${authAction}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ username, password })
        });
        const result = await response.json();
        alert(result.message);

        if (response.ok && authAction === 'login') {
            currentUser = result.user;
            localStorage.setItem('erp_user', JSON.stringify(currentUser));
            document.getElementById('loginForm').reset();
            initApp();
        }
    } catch (err) { console.error(err); }
}

function logout() {
    localStorage.removeItem('erp_user');
    currentUser = null;
    initApp();
}

// ==========================================
// 2. OBSŁUGA MAGAZYNU (PRODUKTY)
// ==========================================
async function fetchProducts() {
    try {
        const response = await fetch(`${BASE_URL}/products.php`);
        localProducts = await response.json();
        renderProductsTable(localProducts);
        populateProductSelect(localProducts);
    } catch (err) { console.error(err); }
}

function renderProductsTable(products) {
    const tbody = document.getElementById('productsTableBody');
    tbody.innerHTML = '';
    products.forEach(p => {
        const row = document.createElement('tr');
        
        const adminActions = currentUser && currentUser.role === 'admin' 
            ? `<button onclick="openEditModal(${p.id})" class="text-blue-600 hover:text-blue-900 font-bold mr-2 cursor-pointer">Edytuj</button>` 
            : `<span class="text-gray-400 text-xs">Brak uprawnień</span>`;

        row.innerHTML = `
            <td class="px-4 py-3 font-mono text-xs">${p.sku}</td>
            <td class="px-4 py-3 font-medium">${p.name}</td>
            <td class="px-4 py-3 text-gray-500">${p.category}</td>
            <td class="px-4 py-3 font-bold">${parseFloat(p.price).toFixed(2)} PLN</td>
            <td class="px-4 py-3">
                <span class="px-2 py-0.5 rounded text-xs font-bold ${p.stock > 0 ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                    ${p.stock} szt.
                </span>
            </td>
            <td class="px-4 py-3 text-right">${adminActions}</td>
        `;
        tbody.appendChild(row);
    });
}

// ==========================================
// 3. EDYCJA PRODUKTÓW (MODAL DLA ADMINA)
// ==========================================
function openEditModal(productId) {
    const product = localProducts.find(p => p.id == productId);
    if (!product) return;

    document.getElementById('editId').value = product.id;
    document.getElementById('editName').value = product.name;
    document.getElementById('editSku').value = product.sku;
    document.getElementById('editCategory').value = product.category;
    document.getElementById('editPrice').value = product.price;
    document.getElementById('editStock').value = product.stock;

    document.getElementById('editModal').classList.remove('hidden');
}

function closeEditModal() {
    document.getElementById('editModal').classList.add('hidden');
}

async function handleEditSubmit(e) {
    e.preventDefault();

    const updatedData = {
        id: document.getElementById('editId').value,
        name: document.getElementById('editName').value,
        sku: document.getElementById('editSku').value,
        category: document.getElementById('editCategory').value,
        price: document.getElementById('editPrice').value,
        stock: document.getElementById('editStock').value
    };

    try {
        const response = await fetch(`${BASE_URL}/products.php`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(updatedData)
        });
        const result = await response.json();
        alert(result.message);

        if (response.ok) {
            closeEditModal();
            fetchProducts();
        }
    } catch (err) { console.error(err); }
}

// ==========================================
// 4. MODUŁ FAKTURY (DODAWANIE DO KOSZYKA)
// ==========================================
function populateProductSelect(products) {
    const select = document.getElementById('invProductSelect');
    select.innerHTML = '';
    products.forEach(p => {
        const option = document.createElement('option');
        option.value = p.id;
        option.innerText = `${p.name} (${p.stock} szt.) - ${p.price} PLN`;
        select.appendChild(option);
    });
}

function addItemToInvoice() {
    const select = document.getElementById('invProductSelect');
    const productId = select.value;
    const qty = parseInt(document.getElementById('invProductQty').value);

    if (!productId || qty < 1) return;
    const product = localProducts.find(p => p.id == productId);
    if (!product) return;

    if (qty > product.stock) {
        alert(`Niewystarczający stan magazynowy! Maksymalnie dostępnych: ${product.stock}`);
        return;
    }

    const existing = currentInvoiceItems.find(item => item.product_id == productId);
    if (existing) {
        if (existing.quantity + qty > product.stock) { 
            alert("Łączna ilość w koszyku przekracza stan magazynowy!"); 
            return; 
        }
        existing.quantity += qty;
    } else {
        currentInvoiceItems.push({ 
            product_id: productId, 
            name: product.name, 
            quantity: qty, 
            price: parseFloat(product.price) 
        });
    }
    renderInvoiceItems();
}

function renderInvoiceItems() {
    const list = document.getElementById('invoiceItemsList');
    list.innerHTML = currentInvoiceItems.length === 0 ? '<li class="text-gray-400 italic text-center">Brak pozycji.</li>' : '';
    currentInvoiceItems.forEach((item, index) => {
        const li = document.createElement('li');
        li.className = 'flex justify-between items-center bg-white p-1 rounded border border-gray-100';
        li.innerHTML = `<span>${item.name} x <b>${item.quantity}</b></span><button type="button" onclick="removeItemFromInvoice(${index})" class="text-red-500 font-bold px-1 cursor-pointer">✕</button>`;
        list.appendChild(li);
    });
}

function removeItemFromInvoice(index) {
    currentInvoiceItems.splice(index, 1);
    renderInvoiceItems();
}

// ==========================================
// 5. ZATWIERDZENIE FAKTURY I WYDRUK
// ==========================================
async function handleInvoiceSubmit(e) {
    e.preventDefault();
    if (currentInvoiceItems.length === 0) { alert("Koszyk faktury jest pusty!"); return; }

    // Pobranie wartości z nowych, rozbitych pól adresowych
    const clientStreet = document.getElementById('invoiceClientStreet').value;
    const clientHomeNumber = document.getElementById('invoiceClientHomeNumber').value;
    const clientPostcode = document.getElementById('invoiceClientPostcode').value;
    const clientCity = document.getElementById('invoiceClientCity').value;

    const invoiceData = {
        client_name: document.getElementById('invClientName').value,
        client_nip: document.getElementById('invClientNip').value || 'Brak NIP',
        client_street: clientStreet,
        client_home_number: clientHomeNumber,
        client_postcode: clientPostcode,
        client_city: clientCity,
        seller_id: currentUser.id,
        items: currentInvoiceItems
    };

    try {
        const response = await fetch(`${BASE_URL}/invoices.php`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(invoiceData)
        });
        
        const result = await response.json();

        if (response.ok && result.success) {
            const printData = {
                invoice_number: result.invoice_number,
                client_name: result.client_name,
                client_street: result.client_street,
                client_home_number: result.client_home_number,
                client_postcode: result.client_postcode,
                client_city: result.client_city,
                client_nip: result.client_nip,
                seller_username: currentUser.username,
                items: result.items
            };

            sessionStorage.setItem('invoice_to_print', JSON.stringify(printData));
            window.open('print-invoice.html', '_blank');

            document.getElementById('invoiceForm').reset();
            currentInvoiceItems = [];
            renderInvoiceItems();
            fetchProducts();
        } else {
            alert(result.message || "Błąd podczas generowania faktury.");
        }
    } catch (err) { console.error(err); }
}

// ==========================================
// 6. PANEL ADMINA: AKCEPTACJA PRACOWNIKÓW
// ==========================================
async function fetchUnapprovedUsers() {
    try {
        const response = await fetch(`${BASE_URL}/admin.php`);
        const users = await response.json();
        const list = document.getElementById('unapprovedUsersList');
        list.innerHTML = users.length === 0 ? '<li class="text-xs text-gray-400 italic py-2">Brak nowych zgłoszeń.</li>' : '';
        users.forEach(u => {
            const li = document.createElement('li');
            li.className = 'flex justify-between items-center py-2 text-sm';
            li.innerHTML = `<span>User: <b>${u.username}</b></span><button onclick="approveUser(${u.id})" class="bg-blue-500 text-white text-xs px-2 py-1 rounded hover:bg-blue-600 cursor-pointer">Zatwierdź</button>`;
            list.appendChild(li);
        });
    } catch (err) { console.error(err); }
}

async function approveUser(userId) {
    try {
        const response = await fetch(`${BASE_URL}/admin.php`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ user_id: userId })
        });
        if (response.ok) { fetchUnapprovedUsers(); }
    } catch (err) { console.error(err); }
}